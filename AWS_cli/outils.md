### STEP FOR INSTALLATION Of KUBERNETES

-[1]- chocolatey
-[2]- aws-cli
```
    choco install awscli
```
-[3]- EKSctl 

```
    choco install eksctl

```
```
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

    sudo mv /tmp/eksctl /usr/local/bin

    eksctl version
```
-[4]- Kubectl-cli
```
   choco install kubernetes-cli 
```
