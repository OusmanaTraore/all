1. [README PROJET KUBERNETES](https://github.com/OusmanaTraore/all/tree/master/PROJET)

2. [ APPLICATION ECSDEMO ](http://afe24b534f2d64968b42a919df88b4de-1401280157.eu-north-1.elb.amazonaws.com/)

    -- kubectl scale deployment ecsdemo-nodejs --replicas=5  

    -- kubectl scale deployment ecsdemo-crystal --replicas=5  

    -- kubectl scale deployment ecsdemo-frontend --replicas=5  


3. [DASHBOARD GRAFANA KUBERNETES CLUSTER ](http://a41e9573df81e4d348922da2455df2da-696240626.eu-north-1.elb.amazonaws.com/d/IPrny1wnz/kubernetes-cluster-monitoring-via-prometheus?orgId=1&refresh=10s)

4. [DASHBOARD GRAFANA KUBERNETES POD ](http://a41e9573df81e4d348922da2455df2da-696240626.eu-north-1.elb.amazonaws.com/d/4XuMd2Iiz/kubernetes-pod-monitoring?orgId=1)

5. [ ARGOCD/EMnObVTJnGOQTvTm](https://a45c9719527624116a8ce4c4db40ad84-932098440.eu-north-1.elb.amazonaws.com/loginreturn_url=https%3A%2F%2Fa45c9719527624116a8ce4c4db40ad84-932098440eu-north-1.elb.amazonaws.com%2Fapplications%2Fmy-kubernetes-argo-app) 


```
    kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname'`

export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

argocd login $ARGOCD_SERVER --username admin --password $ARGO_PWD --insecure

```
    MY_APP="my-kubernetes-argo-app"
    argocd app get ${MY_APP}

    ===> faire le commit

    argocd app sync ${MY_APP}
  