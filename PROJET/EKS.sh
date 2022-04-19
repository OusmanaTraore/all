#!/bin/bash

-[1]- chocolatey
-[2]- aws-cli
```
    choco install awscli
```
-[3]- EKSctl 

```
    choco install eksctl
```

-[4]- Kubectl-cli
```
   choco install kubernetes-cli 
```

### AWS CONFIGURATION
aws configure

### CREATION DU CLUSTER
eksctl create cluster --name projet-ousmana  --version 1.21 --region eu-north-1   --nodes 2 --nodes-min 1 --nodes-max 4 --managed