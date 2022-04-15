#!/bin/bash

quest_resp(){
    echo $QUESTIONS
    read  question
    echo $REPONSES
    read  reponse
    echo -e "
    $QUESTIONS 
    |N-$compteur_question=> $question 
    $REPONSES
    |N-$compteur_question=> $reponse
    " >> question_reponse.txt
}
