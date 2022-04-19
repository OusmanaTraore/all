#!/bin/bash
###Partie 1 - Déployer un cluster K8S et installer les microservices de démos

kubectl apply -f https://raw.githubusercontent.com/fc4it-k8s/ecsdemo-nodejs/master/kubernetes/deployment.yaml


kubectl apply -f https://raw.githubusercontent.com/fc4it-k8s/ecsdemo-nodejs/master/kubernetes/service.yaml

## Exposez le service en tant que node port et visualiser l’output

kubectl expose deployment/ecsdemo-nodejs --type="NodePort" --name=ecsdemo-nodejs

kubectl expose deployment/ecsdemo-nodejs --type="NodePort" --port 8080

kubectl describe services/ecsdemo-nodejs

export NODE_PORT=$(kubectl get services/ecsdemo-nodejs -o go-template='{{(index .spec.ports 0).nodePort}}')

echo NODE_PORT=$NODE_PORT
NODE_PORT=31373
SERVICE_NODE_IP="13.51.146.164"

curl $SERVICE_NODE_IP:$NODE_PORT

### Mettre à l'echelle le déploiment ( passer de 1 à 3 réplicas)

### Mettez à jour la version de Kubernetes vers la version 1.21
kubectl version
Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.1", GitCommit:"206bcadf021e76c27513500ca24182692aabd17e", GitTreeState:"clean", BuildDate:"2020-09-09T11:26:42Z", GoVersion:"go1.15", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.1", GitCommit:"206bcadf021e76c27513500ca24182692aabd17e", GitTreeState:"clean", BuildDate:"2020-09-09T11:18:22Z", GoVersion:"go1.15", Compiler:"gc", Platform:"linux/amd64"}

upgrade(){
echo -e "
UPDATE
"
sudo apt update

echo -e "
Verification des version disponibles
# find the latest 1.20 version in the list
# it should look like 1.20.x-00, where x is the latest patch
"
sudo apt-cache madison kubeadm
read -p " Entrez la version voulue pour l'upgrade" version

sudo apt-mark unhold kubeadm 
sudo  apt-get update
sudo  apt-get install -y kubeadm=$version 
sudo  apt-mark hold kubeadm
}

#kubeadm | 1.20.15-00 | http://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
#kubeadm | 1.21.11-00 | http://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
    
##

sudo apt-mark unhold kubeadm && sudo  apt-get update && sudo  apt-get install -y kubeadm=1.20.15-00 && sudo  apt-mark hold kubeadm


kubeadm version

sudo  kubeadm upgrade plan

sudo  kubeadm upgrade apply v1.20.15
sudo  kubeadm upgrade apply v1.21.11

|> sudo kubeadm upgrade node

kubectl drain <node-to-drain> --ignore-daemonsets
kubectl drain ip-172-31-33-13  --ignore-daemonsets

sudo apt-mark unhold kubelet kubectl

sudo apt-get install -y kubelet=1.20.15-00 kubectl=1.20.15-00
sudo apt-get install -y kubelet=1.21.11-00  kubectl=1.21.11-00 

sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl get node
kubectl uncordon ip-172-31-33-13
kubectl get node

#### ON WORKER
sudo apt-mark unhold kubeadm

sudo apt-get update && sudo apt-get install -y kubeadm=1.20.15-00
sudo apt-get update && sudo apt-get install -y kubeadm=1.21.11-00

sudo apt-mark hold kubeadm
#######

kubectl drain worker --ignore-daemonsets
kubectl drain ip-172-31-46-105 --ignore-daemonsets

### ON WORKER
sudo kubeadm upgrade node
sudo apt-mark unhold kubelet kubectl

sudo apt-get install -y kubelet=1.20.15-00 kubectl=1.20.15-00
sudo apt-get install -y kubelet=1.21.11-00 kubectl=1.21.11-00

sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
####
kubectl uncordon ip-172-31-46-105
kubectl get node

############ DASHBOARD KUBERNETES
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml

kubectl apply -f kubernets-dashboard-adminuser.yaml
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" 1> my_tocken 

kubectl create clusterrolebinding dashaccess --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:kubernetes-dashboard

sendCommand(SecurityInterstitialCommandId.CMD_PROCEED)