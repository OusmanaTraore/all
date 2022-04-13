#!/bin/bash

## Create namespace 
kubectl create namespace argocd

## Installation des composant
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.4/manifests/install.yaml

### Installation d'ARGO CD CLI
sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.0.4/argocd-linux-amd64

sudo chmod +x /usr/local/bin/argocd

### Configuration d'ARGOCD
##Expose argocd-server
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type":"LoadBalancer"}}'
sudo apt install jq -y
export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname'`

##Login with Admin
export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`


argocd login $ARGOCD_SERVER --username admin --password $ARGO_PWD --insecure

### Deploy an application
git clone https://github.com/brentley/ecsdemo-nodejs.git

### create application
export GITHUB_USERNAME="OusmanaTraore"
CONTEXT_NAME=`kubectl config view -o jsonpath='{.current-context}'`
argocd cluster add $CONTEXT_NAME

kubectl create namespace ecsdemo-nodejs
argocd app create ecsdemo-nodejs --repo https://github.com/${GITHUB_USERNAME}/ecsdemo-nodejs.git --path kubernetes --dest-server https://kubernetes.default.svc --dest-namespace ecsdemo-nodejs
argocd app get ecsdemo-nodejs


## Synchronisation
argocd app sync ecsdemo-nodejs


### Accès interface ARGOCD
echo $ARGOCD_SERVER

### Login admin / $ARGO_PWD


############=============================CLEAN UP=============================###############
argocd app delete ecsdemo-nodejs -y
watch argocd app get ecsdemo-nodejs

kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.4/manifests/install.yaml
kubectl delete ns argocd
kubectl delete ns ecsdemo-nodejs

### ====================== WEBHOOK ========================
# sudo tar xvzf ~/Downloads/ngrok-stable-linux-amd64.tgz -C /usr/local/bin
# curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null &&
# echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list &&
# sudo apt update && sudo apt install ngrok   
              
# snap install ngrok
# ## Add auth token
# ngrok authtoken <token>

# ## Start a tunnel
# ngrok http 80