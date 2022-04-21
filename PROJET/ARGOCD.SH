#!/bin/bash



kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.4/manifests/install.yaml

### ARGO CD CLI
curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.0.4/argocd-linux-amd64

sudo chmod +x /usr/local/bin/argocd

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname'`

export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

argocd login $ARGOCD_SERVER --username admin --password $ARGO_PWD --insecure

https://github.com/brentley/ecsdemo-nodejs.git

CONTEXT_NAME=`kubectl config view -o jsonpath='{.current-context}'`
argocd cluster add $CONTEXT_NAME
MY_GITHUB_USERNAME="OusmanaTraore"
MY_APP="my-app"
MY_NAMESPACE="argo-project"
MY_REPO="https://github.com/OusmanaTraore/all.git"
MY_PATH="PROJET/ARGO/"

kubectl create namespace ${MY_NAMESPACE}
argocd app create ${MY_APP} --repo  ${MY_REPO} --path ${MY_PATH}  --dest-server https://kubernetes.default.svc --dest-namespace ${MY_NAMESPACE}

argocd app get ${MY_APP}

argocd app sync ${MY_APP}



echo $ARGOCD_SERVER


# argocd app delete ecsdemo-nodejs -y
# watch argocd app get ecsdemo-nodejs


# kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.4/manifests/install.yaml

# kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.4/manifests/install.yaml
