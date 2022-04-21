#!/bin/bash

# ## 1- AWS configuration (local machine to cluster)
# export REGION="eu-north-1"
# export CLUSTERNAME="ousmana-project-eks2"
# aws sts get-caller-identity
# aws eks --region ${REGION} update-kubeconfig --name ${CLUSTERNAME}
# kubectl get pods --kubeconfig ./.kube/config

### Deployement Prometheus et Installation de HELM




helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl create namespace prometheus
helm repo update 
helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"

### Déploiement de GRAFANA 
prometheus-server.prometheus.svc.cluster.local

POD_NAME=prometheus-pushgateway-659ddb9789-dr2b5

kubectl get all -n prometheus
kubectl port-forward -n prometheus deploy/prometheus-server 8080:9090

mkdir  -p environment/grafana

cat << EoF > /grafana/grafana.yaml
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

helm install grafana grafana/grafana --namespace grafana --set persistence.storageClassName="gp2" --set persistence.enabled=true --set adminPassword='admin' --values environment/grafana/grafana.yaml --set service.type=LoadBalancer

kubectl get all -n grafana

export ELB=$(kubectl get svc -n grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "http://$ELB"

kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
