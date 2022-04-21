#!/bin/bash

sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.0.4/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type":"LoadBalancer"}}'

export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq
--raw-output '.status.loadBalancer.ingress[0].hostname'`

export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o
jsonpath="{.data.password}" | base64 -d`

argocd login $ARGOCD_SERVER --username admin --password $ARGO_PWD --insecure


CONTEXT_NAME=`kubectl config view -o jsonpath='{.current-context}'`
argocd cluster add $CONTEXT_NAME

kubectl create namespace ecsdemo-nodejs

argocd app create ecsdemo-nodejs --repo
https://github.com/GITHUB_USERNAME/ecsdemo-nodejs.git --path kubernetes
--dest-server https://kubernetes.default.svc --dest-namespace ecsdemo-nodejs

argocd app get ecsdemo-nodejs

argocd app sync ecsdemo-nodejs

##### UPDATE DEPLOIMENt (REPLICAS)

### ARGO WEB INTERFACE 
echo $ARGOCD_SERVER