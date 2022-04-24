# PROJET KUBERNETES

## Ce projet est constitué de 5 parties. 
### La première partie concerne l'installation d'un cluster  kubeadm  et déploiement d'application
### La deuxième partie concerne la migration du cluster vers EKS
### La troisième partie concerne la surveillance avec Prometheus et Grafana
### La quatrième partie concerne le déploiement continu avec ARGOCD
### La cinquième partie concerne la securité avec KUBE-BENCH 

---
### Partie 1: Installation d'un cluster  kubeadm  et déploiement d'application

1. Déployer un cluster K8S et installer les microservices de demos
    * Dépliement d'un cluster kubernetes 1.19
    L'installation de kubeadm à été réaliser à l'aide de script depuis l'url suivant:  

    [SCRIPT=> Installation d'un cluster k8s](https://github.com/OusmanaTraore/kubernetes/tree/master/kubernetes_fundamental/Installation_kubernetes%20_V2) 
    
    * Déployez l’application de démos (Hello from nodejs)
    * Mise à jour de version de Kubernetes vers la version 1.21
        - elle se fait en deux étape:
        1. mise à jour depuis la version 1.19 vers la version 1.20
        2.  mise à jour depuis la version 1.20 vers la version 1.21  

        [SCRIPT=> Mise à jour de kubeadm](https://raw.githubusercontent.com/OusmanaTraore/all/master/PROJET/upgrade.sh) 

    * Configuration du dashboard de Kubernetes.

        ```
        kubectl create -f https://bit.ly/2OFQRMy
        kubectl get svc --all-namespaces
        kubectl -n kubernetes-dashboard edit svc kubernetes-dashboard

        # ....
        # selector:
        # k8s-app: kubernetes-dashboard
        # sessionAffinity: None
        # type: NodePort #<-- Edit this line
        # status:
        # loadBalancer: {}

        kubectl -n kubernetes-dashboard get svc kubernetes-dashboard
        kubectl create clusterrolebinding dashaccess --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:kubernetes-dashboard
        kubectl -n kubernetes-dashboard describe secrets kubernetes-dashboard-token-<XXXX-XXXX>
        ``` 
        Accedez au dashboard depuis le navigateur internet puis inspecter le et entrer la commande suivante depuis la console  

        ![kubernetesDashboard](images/login.png)  

        sendCommand(SecurityInterstitialCommandId.CMD_PROCEED)  
        
        puis recpuerez le token depuis votre console

        ![kubernetesDashboard](images/kubernetesDashboard.png)
        
---
2. Migration vers EKS
    ```
        ## MISE A JOUR DE EKS
        CLUSTERNAME="ousmana-project-eks2"
        eksctl upgrade cluster --name ${CLUSTERNAME} --approve

        eksctl upgrade nodegroup --name=ng-cb32905d --cluster=ousmana-project-eks2 --kubernetes-version=1.21

        ### Mise a jour CORE DNS
        eksctl get addon --name coredns --cluster ${CLUSTERNAME}
        eksctl utils update-coredns --cluster=${CLUSTERNAME} --approve
        kubectl describe deployment coredns --namespace kube-system | grep Image | cut -d "/" -f 3

        ### Mise a jour Kube-proxy
        eksctl utils update-kube-proxy --cluster=${CLUSTERNAME} --approve

        kubectl get daemonset kube-proxy --namespace kube-system -o=jsonpath='{$.spec.template.spec.containers[:1].image}'
        kubectl describe deployment coredns --namespace kube-system | grep Image | cut -d "/" -f 3
    ```
    Accéder à l'application escdemo en cliquant sur le lien suivant: 
    
     [ecsdemo](http://afe24b534f2d64968b42a919df88b4de-1401280157.eu-north-1.elb.amazonaws.com) 
---
3. Surveillance avec PROMETHEUS et GRAFANA
---
4. Déploiement continu avec ARGOCD
---
5. CIS EKS BENCHMARK ASSESSMENT USING KUBE-BENCH
