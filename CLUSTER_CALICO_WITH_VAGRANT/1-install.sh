#!/bin/bash

sudo apt update
sudo apt install docker.io
sudo systemctl enable docker 
###
sudo kubeadm init --pod-network-cidr=192.168.0.0/16


kubectl delete -f https://docs.projectcalico.org/manifests/calico.yaml
wget https://docs.projectcalico.org/manifests/calico.yaml



var_autodetection="\            - name: IP_AUTODETECTION_METHOD"
sed -i -e "4194a  ${var_autodetection}" calico.yaml

var_interface="\              value: \"interface=eth*\""
sed -i -e "4195a  ${var_interface}" calico.yaml
awk ' {print NR "-" , $0 }' calico.yaml | grep '4193\|4194\|4195\|4196\|4197\|4198'



awk '$0 == "apiVersion: policy/v1beta1" { print NR ":" ,$0 }'  calico.yaml 

var_api_new_version="apiVersion: policy/v1"
var_api_old_version="apiVersion: policy/v1beta1"

sed -i "4421d" calico.yaml
sed -i -e "4420a  ${var_api_new_version}" calico.yaml

awk '$0 == "apiVersion: policy/v1" { print NR ":" ,$0 }'  calico.yaml 

#sed  -i   "s/$var_api_old_version/$var_api_new_version/g" calico.yaml
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl get pods --all-namespaces