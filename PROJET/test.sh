#!/bin/bash
read -p "|> " touche
while [ $touche != "done" ]
do
 echo "tap 'done', then press 'enter' to continue ..."
 read -p "|> " touche
done