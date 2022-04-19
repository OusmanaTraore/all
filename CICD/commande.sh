#!/bin/bash

### From KATACODA TRAINING
if [ ! -d "kubernetes-lab" ] ; then
   git clone https://github.com/loodse/kubernetes-lab.git
fi
cat <<EOF >> ~/.bashrc
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
cd s
Readiness probe failed: calico/node is not ready: BIRD is not ready: Failed to stat() nodename file: stat /var/lib/calico/nodename