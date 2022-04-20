#!/bin/bash


#===
echo "==================================="
echo -e "##-1-## Vérification du status"

INIT_REPO=".git"

if [ -d $INIT_REPO ]  
then
	echo " Repo git trouvé"
else 
	echo -e  " 
	$INIT_REPO non trouvé ,
	Initialisation du repos ! "
	git init
fi

git status
echo "==================================="
#===
echo""
echo "==================================="
echo -e "##-2-## Ajout des fichiers"
read -p "Veuillez ajouter vos fichier: " fichier
if [ $fichier!="--all" ] || [ $fichier!="." ]
then
	echo "Ajout de vos fichiers : $fichier"
	git add $fichier
else
	echo "Ajout de tous les fichiers"
	git add --all 
fi
echo "==================================="

#===
echo""
echo "==================================="
echo -e "##-3-## Vérification du status"
git status
echo "==================================="

#===
echo""
echo "==================================="
echo -e "##-4-## Commit des fichiers"
read -p "entrez votre message de commit: " message
git commit -m "$message"
echo "==================================="

#===
echo""
echo "==================================="
echo -e "##-5-## Vérification du status"
git status
echo "==================================="

#===
echo""
echo "==================================="
echo -e "##-6-## Push des fichiers vers le repos distant"

read -p "Veuillez entrez votre remote : " remote_push
echo -e "================================== "
read -p "Veuillez entrez votre branche pour le push: " branche_push
git push $remote_push $branche_push
echo "==================================="

#===
echo""
echo "==================================="
if [ $branche_push  ]
then
	echo -e "##-7-##   Push OK...     ##-7-## "
	echo "============= FIN DU PUSH , FIN DU PROGRAMME ==================="
else
	echo -e " 
	Revérifiez votre branche,
	puis relancez le script
	 "

fi
sleep 3
