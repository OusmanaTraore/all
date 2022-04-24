#!/bin/bash

####==================== VARIABLES =========================
$version_short=$(echo $version_full  | cut -d "-" -f 1)

####==================== VARIABLES =========================

####==================== FONCTIONS =========================
kubeadm_version_full(){

sudo  apt-mark unhold kubeadm

sudo  apt-get install -y kubeadm=$version_full
sudo  apt-mark hold kubeadm
sudo kubeadm version
kubectl get nodes
sleep 2
}

pre_upgrade(){
sudo  kubeadm upgrade apply v$version_short
kubectl get node
sleep 2
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=$version_full  kubectl=$version_full 
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl get node
sleep 2
kubectl uncordon $master
kubectl get node
sleep 2
}

upgrade_worker1(){   
sudo apt-mark unhold kubeadm
sudo  apt-get install -y kubeadm=$version_full
sudo apt update && sudo  apt-mark hold kubeadm
sudo apt-mark hold kubeadm
}

upgrade_master_suite(){
kubectl drain $worker --ignore-daemonsets
}

upgrade_worker2F(){
sudo kubeadm upgrade node
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=$version_full  kubectl=$version_full
sudo apt-mark hold kubelet kubectl 
sudo systemctl daemon-reload
sudo systemctl restart kubelet
}

upgrade_master_fin(){
kubectl get node
kubectl uncordon $worker
kubectl get nodes
}

do_check(){
read -p "|> " touche
while [ $touche != "done" ]
do
 echo "tap 'done', then press 'enter' to continue ..."
 read -p "|> " touche
done
}

####==================== FONCTIONS =========================



####==================== UPGRADE =========================
upgrade(){
echo -e "
|> UPDATE
"
sudo apt update

echo -e "
|>  Verification des version disponibles
# find the latest 1.20 version in the list
# it should look like 1.20.x-00, where x is the latest patch
"
sudo apt-cache madison kubeadm

read -p " Entrez la version voulue pour l'upgrade: " version_full

kubeadm_version_full
read -p "Entrez le nom du noeud master: " master

echo -e "
|> DRAIN du master: $master
"
kubectl drain $master --ignore-daemonsets

echo -e "
|> UPGRADE PLAN
"
sudo  kubeadm upgrade plan
# $version_short=$(echo $version_full  | cut -d "-" -f 1)
echo -e "
|> UPGRADE APPLY version:v$version_short
"
pre_upgrade
echo -e "
|> GO ON WORKER AND EXECUTE \"upgrade worker1\": $master
"
sleep 2
echo -e "
|> WAITING FOR JOB  IN WORKER, IF DONE, TAP 'done' and  then  press 'enter' to continue...
"
do_check
### ON-WORKER ###
upgrade_worker1
echo -e "
|> GO ON MASTER AND TAP 'done', to continue ...
"
do_check
### FIN ON-WORKER
upgrade_master_suite
do_check
echo -e "
|> GO ON WORKER AND EXECUTE \"upgrade worker2F\"
"
### ON-WORKER ###
upgrade_worker2F
echo -e "
|> GO ON MASTER AND TAP 'done', to continue ...
"
do_check
### FIN ON-WORKER
upgrade_master_fin

}

####==================== UPGRADE =========================