#!/bin/bash

####==================== VARIABLES =========================
version_short=$(echo $version_full  | cut -d "-" -f 1)

####==================== VARIABLES =========================

####==================== FONCTIONS =========================

kubeadm_version_full(){

sudo  apt-mark unhold kubeadm

sudo  apt-get install -y kubeadm=$version_full
sudo  apt-mark hold kubeadm
sudo kubeadm version
kubectl get nodes
sleep 2
}

pre_upgrade(){
sudo  kubeadm upgrade apply v$version_short
kubectl get node
sleep 2
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=$version_full  kubectl=$version_full 
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl get node
sleep 2
kubectl uncordon $master_name
kubectl get node
sleep 2
}

upgrade_worker1(){   
sudo apt-mark unhold kubeadm
sudo  apt-get install -y kubeadm=$version_full
sudo apt update && sudo  apt-mark hold kubeadm
sudo apt-mark hold kubeadm
}

upgrade_master_suite(){
kubectl drain $worker_name --ignore-daemonsets
}

upgrade_worker2F(){
sudo kubeadm upgrade node
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=$version_full  kubectl=$version_full
sudo apt-mark hold kubelet kubectl 
sudo systemctl daemon-reload
sudo systemctl restart kubelet
}

upgrade_master_fin(){
kubectl get node
kubectl uncordon $worker_name
kubectl get nodes
}

do_check(){
read -p "|>  " touche
while [ $touche != "done" ]
do
 echo "tap 'done', then press 'enter' to continue ..."
 read -p "|> " touche
done
}

####==================== FONCTIONS =========================



####==================== UPGRADE =========================

upgrade(){
read -p "|> " choix;

        case $choix in
            "")         echo "No option was specified."; exit 1 ;;
            master)     
                        ### FIRST PART        
                        echo -e "
                        |> UPDATE
                        "
                        sudo apt update

                 
                        sudo apt-cache madison kubeadm

                        version_kube_v=$(kubeadm version | cut -d " " -f 5 | cut -d "\"" -f 2) 
                        version_kube=$(kubeadm version | cut -d " " -f 5 | cut -d "\"" -f 2 | cut -d "v" -f 2)
                        echo -e "
                        |>  Version actuelle : $version_kube_v
                        # find above the latest  version to upgrade 
                        # it should look like $version_kube-00, where x is the latest patch
                        "
                        read -p " Entrez la version voulue pour l'upgrade: " version_full

                        echo -e "
                        |> Appel de la fonction  kubeadm_version_full: 
                        "
                        kubeadm_version_full

                        master_ip=$(kubectl get node| grep master  | cut -d "-" -f 2-5 | sed s/-/./g| cut -d " " -f 1)

                         echo -e "
                        |> Adresse IP master:  $master_ip
                        "
                        # read -p "Entrez le nom du noeud master: " master
                        master_name=$(kubectl get node| grep master  | cut -d " " -f 1)
                        echo -e "
                        |> DRAIN du master: $master_name
                        "
                        kubectl drain $master_name --ignore-daemonsets

                        echo -e "
                        |> UPGRADE PLAN
                        "
                        sudo  kubeadm upgrade plan
                        version_short=$(echo $version_full  | cut -d "-" -f 1)
                        echo -e "
                        |> UPGRADE APPLY version:v$version_short
                        "
                          echo -e "
                        |> Appel de la fonction  pre_upgrade: 
                        "
                        pre_upgrade
                        echo -e "
                        |> GO ON WORKER AND TAP 'done', to continue ...
                        "
                        sleep 2
                        echo -e "
                        |> WAITING FOR JOB  IN WORKER, IF DONE, TAP 'done' and  then  press 'enter' to continue...
                        "
                        do_check
                        ### SECOND PART
                          echo -e "
                        |> Appel de la fonction  upgrade_master_suite: 
                        "
                        worker_name=$(kubectl get node| grep none  | cut -d " " -f 1)
                        upgrade_master_suite
                         echo -e "
                        |> GO ON WORKER AND TAP 'done', to continue ...
                        "
                        sleep 2
                        echo -e "
                        |> WAITING FOR JOB  IN WORKER, IF DONE, TAP 'done' and  then  press 'enter' to continue...
                        "
                        do_check
                        ### THIRD PART
                          echo -e "
                        |> Appel de la fonction  upgrade_master_fin: 
                        "
                        upgrade_master_fin ;;
            worker)     
                        ### FIRST PART
                        ### ON-WORKER ###
                         echo -e "
                        |> UPDATE
                        "
                        sudo apt update

                 
                        sudo apt-cache madison kubeadm

                        version_kube_v=$(kubeadm version | cut -d " " -f 5 | cut -d "\"" -f 2) 
                        version_kube=$(kubeadm version | cut -d " " -f 5 | cut -d "\"" -f 2 | cut -d "v" -f 2)
                        echo -e "
                        |>  Version actuelle : $version_kube_v
                        # find above the latest  version to upgrade 
                        # it should look like $version_kube-00, where x is the latest patch
                        "
                        read -p " Entrez la version voulue pour l'upgrade: " version_full


                    

                           echo -e "
                        |> Appel de la fonction  upgrade_worker1: 
                        "
                        upgrade_worker1
                        echo -e "
                        |> GO ON MASTER AND TAP 'done', to continue ...
                        "
                        sleep 2
                        echo -e "
                        |> WAITING FOR JOB  IN MASTER, IF DONE, TAP 'done' and  then  press 'enter' to continue...
                        "
                        do_check
                        ### FIN ON-WORKER
                        ### SECOND PART
                        ### ON-WORKER ###
                           echo -e "
                        |> Appel de la fonction  upgrade_worker2F: 
                        "
                        upgrade_worker2F
                        echo -e "
                        |> UPGRADE SUCCESSFULL, CHECK ON MASTER!
                        "
                         echo -e "
                        |> GO ON MASTER AND TAP 'done', to continue ...
                        ";;
                        ### FIN ON-WORKER
            
            *)          echo "this case is NOT IMPLEMENTED ."; exit 1 ;;
        esac

}

####==================== UPGRADE =========================
echo  -e "
|> TAP master if working on master
|> TAP worker if working on worker
"
# read $1;
upgrade 