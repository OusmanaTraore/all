#!/bin/bash

echo -e "
=================================================================================
||||            Lister les fichier a indexer                                 ||||
                exemple --all ou file1,file2 etc
=================================================================================
"
read file_to_add
git add $file_to_add

if [ $# -eq 0 ]
then
do
$file_to_add="--all"
done

git status
sleep 2
echo -e "
=================================================================================
||||            Entrez votre message de commit                               ||||
                
=================================================================================
"
read message_to_commit
git commit -m $message_to_commit

git status
sleep 2

echo -e "
=================================================================================
||||     Entrez votre branche sur laquelle vous pushez  <branch-name>      ||||
                     exemple1 : origin
                     exemple2 : master 
=================================================================================
"
read  branch_to_push
git push $branch_to_push