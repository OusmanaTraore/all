#!/bin/bash
###Partie 1 - Déployer un cluster K8S et installer les microservices de démos

kubectl apply -f https://raw.githubusercontent.com/fc4it-k8s/ecsdemo-nodejs/master/kubernetes/deployment.yaml


kubectl apply -f https://raw.githubusercontent.com/fc4it-k8s/ecsdemo-nodejs/master/kubernetes/service.yaml

## Exposez le service en tant que node port et visualiser l’output

kubectl get svc
kubectl edit svc ecsdemo-nodejs

# kubectl expose deployment/ecsdemo-nodejs --type="NodePort" --name=ecsdemo-nodejs

# kubectl expose deployment/ecsdemo-nodejs --type="NodePort" --port 8080

# kubectl describe services/ecsdemo-nodejs

export NODE_PORT=$(kubectl get services/ecsdemo-nodejs -o go-template='{{(index .spec.ports 0).nodePort}}')

echo $NODE_PORT
SERVICE_NODE_IP="16.170.239.57"

curl $SERVICE_NODE_IP:$NODE_PORT

### Mettre à l'echelle le déploiment ( passer de 1 à 3 réplicas)
kubectl edit deployment/ecsdemo-nodejs

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

sudo  apt-get install -y kubeadm=$version 
sudo  apt-mark hold kubeadm

}

#kubeadm | 1.20.15-00 | http://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
#kubeadm | 1.21.11-00 | http://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
    
##

kubeadm version
sudo apt-mark unhold kubeadm && sudo  apt-get update && sudo  apt-get install -y kubeadm=1.20.15-00 && sudo  apt-mark hold kubeadm



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

############  METRICS AND DASHBOARD KUBERNETES
### METRICS

git clone https://github.com/kubernetes-incubator/metrics-server.git
cd metrics-server

kubectl create -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
kubectl -n kube-system get pods
kubectl -n kube-system edit deployment metrics-server

# ....
#  spec:
#  containers:
#  - args:
#  - --cert-dir=/tmp
#  - --secure-port=4443
#  - --kubelet-insecure-tls #<-- Add this line
#  - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname #<--May be needed
#  image: k8s.gcr.io/metrics-server/metrics-server:v0.3.7

kubectl -n kube-system logs metrics-server-XXXX-XXXX
sleep 120 ; kubectl top pod --all-namespaces
kubectl top nodes

curl --cert ./client.pem --key ./client-key.pem --cacert ./ca.pem https://k8smaster:6443/apis/metrics.k8s.io/v1beta1/nodes

##### FIN METRICS =====>

#### DASHBOARD

kubectl create -f https://bit.ly/2OFQRMy
kubectl get svc --all-namespaces
kubectl -n kubernetes-dashboard edit svc kubernetes-dashboard

# ....
# selector:
# k8s-app: kubernetes-dashboard
# sessionAffinity: None
# type: NodePort #<-- Edit this line
# status:
# loadBalancer: {}

kubectl -n kubernetes-dashboard get svc kubernetes-dashboard


kubectl create clusterrolebinding dashaccess --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:kubernetes-dashboard
kubectl -n kubernetes-dashboard describe secrets kubernetes-dashboard-token-<



sendCommand(SecurityInterstitialCommandId.CMD_PROCEED)

##### FIN DASHBOARD =====>