#!/bin/bash

### <========================== FONCTIONS QUESTION-REPONSE    DEBUT =========================>
###  fonction demandant question puis réponse
quest_resp(){
    echo $QUESTIONS
    read  question
    echo $REPONSES
    read  reponse
    echo -e "
    $QUESTIONS 
    |QN-$compteur_question=> $question 
    $REPONSES
    |RN-$compteur_question=> $reponse
    " >> question_reponse.txt
}
### <========================== FONCTIONS QUESTION-REPONSE  FIN =========================>
###
### <========================== FONCTIONS Mode Serie    DEBUT =========================>

### <========================== FONCTIONS Mode Serie    FIN =========================>