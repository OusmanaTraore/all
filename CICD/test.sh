#!/bin/bash


read -p "valeur du compteur: " compteur_question
sed -i -r "s/^(compteur_question_total=).[0-9]*$/\1$compteur_question/"  test.sh

compteur_question_total=