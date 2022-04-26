#!/bin/bash

-[1]- chocolatey
-[2]- aws-cli
```
    choco install awscli
```
export REGION="eu-north-1"
export CLUSTERNAME="ousmana-project-eks2"
aws sts get-caller-identity
aws eks --region ${REGION} update-kubeconfig --name ${CLUSTERNAME}
kubectl get pods --kubeconfig ./.kube/config


-[3]- EKSctl 

```
    choco install eksctl
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version 
-[4]- Kubectl-cli
```
   choco install kubernetes-cli 
```

### AWS CONFIGURATION
aws configure

### CREATION DU CLUSTER
eksctl create cluster --name projet-ousmana  --version 1.21 --region eu-north-1   --nodes 2 --nodes-min 1 --nodes-max 4 --managed

### Deploiement des microservices
1- DEPLOY NODEJS BACKEND API

kubectl apply -f https://raw.githubusercontent.com/OusmanaTraore/all/master/PROJET/nodejs_backend_deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/OusmanaTraore/all/master/PROJET/nodejs_service.yaml


2- DEPLOY CRYSTAL BACKEND API

kubectl apply -f https://raw.githubusercontent.com/OusmanaTraore/all/master/PROJET/crystal_deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/OusmanaTraore/all/master/PROJET/crystal_service.yaml


3- ENSURE THE ELB SERVICE ROLE EXISTS

aws iam get-role --role-name "AWSServiceRoleForElasticLoadBalancing" || aws iam create-service-linked-role --aws-service-name "elasticloadbalancing.amazonaws.com"

4- DEPLOY FRONTEND SERVICE
kubectl apply -f  https://raw.githubusercontent.com/OusmanaTraore/all/master/PROJET/frontend_deployment.yaml
kubectl apply -f  https://raw.githubusercontent.com/OusmanaTraore/all/master/PROJET/ingress.yaml
kubectl apply -f  https://raw.githubusercontent.com/OusmanaTraore/all/master/PROJET/frontend_service.yaml

5- FIND THE SERVICE ADDRESS

kubectl get svc  
export LOADBALANCER="afe24b534f2d64968b42a919df88b4de-1401280157.eu-north-1.elb.amazonaws.com"
export LOADBALANCER_PORT="30573"
 
6- SCALE THE BACKEND SERVICES

kubectl get deployments
kubectl scale deployment ecsdemo-nodejs --replicas=3
kubectl scale deployment ecsdemo-crystal --replicas=10
kubectl get deployments

7- SCALE THE FRONTEND

kubectl scale deployment ecsdemo-frontend --replicas=3

### MISE A JOUR DE EKS
CLUSTERNAME="ousmana-project-eks2"
eksctl upgrade cluster --name ${CLUSTERNAME} --approve


eksctl upgrade nodegroup --name=ng-cb32905d --cluster=ousmana-project-eks2 --kubernetes-version=1.21

### Mise a jour CORE DNS
eksctl get addon --name coredns --cluster ${CLUSTERNAME}
eksctl utils update-coredns --cluster=${CLUSTERNAME} --approve
kubectl describe deployment coredns --namespace kube-system | grep Image | cut -d "/" -f 3

### Mise a jour Kube-proxy
eksctl utils update-kube-proxy --cluster=${CLUSTERNAME} --approve


kubectl get daemonset kube-proxy --namespace kube-system -o=jsonpath='{$.spec.template.spec.containers[:1].image}'
kubectl describe deployment coredns --namespace kube-system | grep Image | cut -d "/" -f 3
