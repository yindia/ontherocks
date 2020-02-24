# !/bin/bash -e

terraform init

# try 3 times in case we are stuck waiting for EKS cluster to come up
set +e
N=0
SUCCESS="false"
until [ $N -ge 3 ]; do
  terraform apply -auto-approve -var-file=./env/master/variables.tfvar -state-out=$(pwd)
  if [[ "$?" == "0" ]]; then
    SUCCESS="true"
    break
  fi
  N=$[$N+1]
done
set -e

if [[ "$SUCCESS" != "true" ]]; then
    exit 1
fi


kubectl apply -f ./k8s/service-account.yaml
kubectl apply -f ./k8s/role-binding.yaml

SECRET_ID=$(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

kubectl -n kube-system get secret $SECRET_ID -o jsonpath='{.data.token}' > /kube/token.txt

echo $SECRET_ID > /kube/SECRET_ID.txt

# Create Namespaces
kubectl create ns database
kubectl create ns dev
kubectl create ns master
kubectl create ns cert-manager

kubectl create serviceaccount tiller --namespace kube-system
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller

helm repo add stable https://kubernetes-charts.storage.googleapis.com

sleep 5

helm install \
  --name cert-manager \
  --namespace kube-system \
  --set ingressShim.defaultIssuerName=letsencrypt-dev \
  --set ingressShim.defaultIssuerKind=ClusterIssuer \
  stable/cert-manager \
  --version v0.3.0

#Setup Mongo Credentials in template  
sed -i -e "s/INPUTUSERNAME/betaapp/g" ./k8s/config/kustomization.yaml
sed -i -e "s/INPUTPASSWORD/$MONGOPASSWORD/g" ./k8s/config/kustomization.yaml

#  create configmap and lestencrypt certificate
./kustomize build ./k8s/config/ | kubectl apply -f -

#Setup Mongo Credentials in Mongodb template  
sed -i -e "s/INPUTUSERNAME/betaapp/g" ./helm/mongodb/values.yaml
sed -i -e "s/INPUTPASSWORD/$MONGOPASSWORD/g" ./helm/mongodb/values.yaml
sed -i -e "s/INPUTROOTPASSWORD/$MONGOROOTPASSWORD/g" ./helm/mongodb/values.yaml

#Install nginx-ingress helm
helm install stable/nginx-ingress \
  --name uck-nginx \
  --set rbac.create=true \
  --namespace kube-system

#Install Mongo Helm
helm template ./helm/mongodb/ > master.yaml
kubectl apply -f master.yaml --namespace=database

#Upload kubeconfig in s3
aws s3 cp /kube/kubeconfig.yaml s3://uaebucketprod/
