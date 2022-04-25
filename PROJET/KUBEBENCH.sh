#!/bin/bash
kubectl get nodes -o wide

KUBEBENCH_URL=$(curl -s https://api.github.com/repos/aquasecurity/kube-bench/releases/latest | jq -r '.assets[] | select(.name | contains("amd64.rpm")) | .browser_download_url')

sudo apt install -y $KUBEBENCH_URL

kube-bench --benchmark eks-1.0

sudo yum remove kube-bench -y
exit
curl -L https://github.com/aquasecurity/kube-bench/releases/download/v0.6.2/kube-bench_0.6.2_linux_amd64.deb -o kube-bench_0.6.2_linux_amd64.deb
sudo apt install ./kube-bench_0.6.2_linux_amd64.deb -f
sudo ./kube-bench --config-dir `pwd`/cfg --config `pwd`/cfg/config.yaml 


####
cat << EOF > job-eks.yaml
---
apiVersion: batch/v1
kind: Job
metadata:
  name: kube-bench
spec:
  template:
    spec:
      hostPID: true
      containers:
        - name: kube-bench
          image: aquasec/kube-bench:latest
          command: ["kube-bench", "--benchmark", "eks-1.0"]
          volumeMounts:
            - name: var-lib-kubelet
              mountPath: /var/lib/kubelet
              readOnly: true
            - name: etc-systemd
              mountPath: /etc/systemd
              readOnly: true
            - name: etc-kubernetes
              mountPath: /etc/kubernetes
              readOnly: true
      restartPolicy: Never
      volumes:
        - name: var-lib-kubelet
          hostPath:
            path: "/var/lib/kubelet"
        - name: etc-systemd
          hostPath:
            path: "/etc/systemd"
        - name: etc-kubernetes
          hostPath:
            path: "/etc/kubernetes"
EOF

kubectl apply -f job-eks.yaml
kubectl get pods --all-namespaces
kubectl logs kube-bench-<value>
kubectl delete -f job-eks.yaml
rm -f job-eks.yaml

cat << EOF > job-debug-eks.yaml
---
apiVersion: batch/v1
kind: Job
metadata:
  name: kube-bench-debug
spec:
  template:
    spec:
      hostPID: true
      containers:
        - name: kube-bench
          image: aquasec/kube-bench:latest
          command: ["kube-bench", "-v", "3", "--logtostderr", "--benchmark", "eks-1.0"]
          volumeMounts:
            - name: var-lib-kubelet
              mountPath: /var/lib/kubelet
              readOnly: true
            - name: etc-systemd
              mountPath: /etc/systemd
              readOnly: true
            - name: etc-kubernetes
              mountPath: /etc/kubernetes
              readOnly: true
      restartPolicy: Never
      volumes:
        - name: var-lib-kubelet
          hostPath:
            path: "/var/lib/kubelet"
        - name: etc-systemd
          hostPath:
            path: "/etc/systemd"
        - name: etc-kubernetes
          hostPath:
            path: "/etc/kubernetes"
EOF

kubectl apply -f job-debug-eks.yaml
kubectl get pods --all-namespaces
kubectl logs kube-bench-debug-<value>

kubectl delete -f job-debug-eks.yaml
rm -f job-debug-eks.yaml

