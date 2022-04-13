#!/bin/bash

### 1- Download Helm repo
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

### 2- Installation de etcd-client
sudo apt  install etcd-client



### 3- Export du ETCD
export ETCDCTL_API=3  
etcdctl -h | grep -A 1 API

sudo head -n 35 /etc/kubernetes/manifests/etcd.yaml  | grep -A 20 containers
export my_directory=/home/ubuntu/backup-cluster_clean

### 4- BACKUP DE ETCD
echo "Backup de ETCD "

sudo ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save ${my_directory}

ETCDCTL_API=3 etcdctl snapshot restore ${my_directory}
