# Ontherocks - Demo App 

![CI](https://github.com/evalsocket/ontherocks/workflows/CI/badge.svg) 

### Directory Structure
```
├── helm
│   │   ├── base
│   │   │   ├── charts (helm charts for demo app)
│   │   │   ├── chartInflator.yaml
│   │   │   ├── kustomization.yaml
│   │   ├── dev
│   │   │   ├── kustomization.yaml
│   │   ├── master
│   │   │   ├── kustomization.yaml
│   │   ├── kustomize(Plugin directory)
│   │   └── kustomization.yaml
├── src (Demo application - to-do)
├── terraform
│   │   ├── env
│   │   │   ├──dev
│   │   │   │   ├──variables.tfvar
│   │   │   ├──master
│   │   │   │   ├──variables.tfvar
│   │   │   ├── chartInflator.yaml
│   │   │   ├── kustomization.yaml
│   │   ├── helm
│   │   │   ├── mongodb (Mongodb Helm)
│   │   ├── k8s
│   │   │   ├──config (Mongo Database secrets)
│   │   ├── modules
│   │   │   ├── provider  
│   │   │   │     ├── ├──aws (Aws Module terraform)
│   │   ├── scripts 
│   │   │     ├── setup.sh
│   │   │     ├── teardown.sh
│   │   ├──  Makefile
│   │   ├──  README.md
│   │   ├──  main.tf
│   │   ├──  output.tf
│   │   ├──  version.tf
│   │   ├──  vriables.tf
├── .gitignore
├── README.md
├── Dockerfile 
├── docker-compose.yml
├── Makefile
```


## prerequest
 - golang (1.13)
 - docker
 - AWS Account 
 
## Env
1. Production (Branch - master)
1. dev (Branch - dev)

## Get started 

 - Setp 1 : cd `terraform` and follow the instruction from README.md
 - Setp 2 : Setup github Pipeline
    ```bash
     # Now in ./terraform/export directory you get the kubeconfig.yaml
     cat ./terraform/export/kubeconfig.yaml  | base64
     # Copy the base64 token and update the github repository secret with name KUBE_CONFIG_DATA
     #  (cat ~/terraform/export/kubeconfig.yaml | base64) - create base64 token
     # Also Update IMAGE_REGISTRY  in github Secret
     
    ```
- step 3 : Now your ready for CICD. Commit,Push,Merge,repeat
