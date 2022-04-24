#!/bin/bash

# ## 1- AWS configuration (local machine to cluster)
# export REGION="eu-north-1"
# export CLUSTERNAME="ousmana-project-eks2"
# aws sts get-caller-identity
# aws eks --region ${REGION} update-kubeconfig --name ${CLUSTERNAME}
# kubectl get pods --kubeconfig ./.kube/config

### Deployement Prometheus et Installation de HELM
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm repo update 

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl create namespace prometheus

helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"

### Déploiement de GRAFANA 


kubectl get all -n prometheus
# kubectl port-forward -n prometheus deploy/prometheus-server 8080:9090

mkdir -p ${HOME}/environment/grafana



cat << EoF > ${HOME}/environment/grafana/grafana.yaml
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus-server.prometheus.svc.cluster.local
      access: proxy
      isDefault: true
EoF


kubectl create namespace grafana
# IF installed failed 
#helm search hub grafana

# helm repo add grafana https://grafana.github.io/helm-charts

# helm repo update

helm install grafana grafana/grafana --namespace grafana --set persistence.storageClassName="gp2" --set persistence.enabled=true --set adminPassword='admin' --values ${HOME}/environment/grafana/grafana.yaml --set service.type=LoadBalancer

kubectl get all -n grafana

export ELB=$(kubectl get svc -n grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "http://$ELB"

kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

#To uninstall GRAFANA  
# helm uninstall prometheus --namespace prometheus
# kubectl delete ns prometheus

# helm uninstall grafana --namespace grafana
# kubectl delete ns grafana

# rm -rf ${HOME}/environment/grafana