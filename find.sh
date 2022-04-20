#!/bin/bash

read -p " Entrez le fichier à rechercher : " fichier_recherche

find / -name $fichier_recherche > fichier_recherche.txt