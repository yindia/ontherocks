#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/../

terraform init

# try 3 times in case we are stuck waiting for EKS cluster to come up
set +e
N=0
SUCCESS="false"
until [ $N -ge 3 ]; do
  terraform destroy -auto-approve -var-file=./env/master/variables.tfvar 
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


