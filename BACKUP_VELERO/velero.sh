#!/bin/bash



## 1- AWS configuration (local machine to cluster)
export REGION="us-west-2"
export CLUSTERNAME="ousmana-cluster-istio"
aws sts get-caller-identity
aws eks --region ${REGION} update-kubeconfig --name ${CLUSTERNAME}
kubectl get pods --kubeconfig ./.kube/config
echo -e "
================================================================
||||         Installation du binaire velero  >              ||||
================================================================
"
## 2-
wget https://github.com/vmware-tanzu/velero/releases/download/v1.3.2/velero-v1.3.2-linux-amd64.tar.gz

echo -e "
================================================================
||||         Extraction du binaire velero  >              ||||
================================================================
"
tar -xvf velero-v1.3.2-linux-amd64.tar.gz -C /tmp

sudo mv /tmp/velero-v1.3.2-linux-amd64/velero /usr/local/bin
velero version
export PATH=$PATH:/usr/local/bin

### 3- Installation de Velero on Client
export BUCKET_NAME="ousmana-bucket2"



velero install \
--provider aws \
--plugins velero/velero-plugin-for-aws:v1.0.1 \
--bucket ${BUCKET_NAME} \
--backup-location-config region=${REGION} \
--snapshot-location-config region=${REGION} \
--secret-file ~/.aws/credentials

kubectl get all -n velero 

## 4- Deploy application test
export NAMESPACE="ousmana-istio"
export MyBACKUP="velero-istio3"
kubectl create namespace ${NAMESPACE}
kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0 -n ${NAMESPACE}
kubectl create deployment nginx --image=nginx -n ${NAMESPACE}

kubectl get deployments -n ${NAMESPACE}

## 5- Backup
velero backup create ${MyBACKUP}  --include-namespaces ${NAMESPACE}

velero backup describe ${MyBACKUP}

### 6- Restore
kubectl delete namespace ${NAMESPACE}

velero restore create --from-backup ${MyBACKUP}