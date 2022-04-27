#!/bin/bash

read  scale;
scale(){
     if [ $1=="1"]
     then
     kubectl scale deployment ecsdemo-nodejs --replicas=10  
     kubectl scale deployment ecsdemo-crystal --replicas=10  
     kubectl scale deployment ecsdemo-frontend --replicas=10 
     elif [ $1=="10"]
     then
     `kubectl scale deployment ecsdemo-nodejs --replicas=10`
     `kubectl scale deployment ecsdemo-crystal --replicas=10` 
     `kubectl scale deployment ecsdemo-frontend --replicas=10` 
     fi
}

