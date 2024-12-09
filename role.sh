#!/bin/bash

# Boucle infinie pour demander le nom du rôle
while true
do
  # Demande du nom du rôle à créer
  read -p 'Quel rôle tu veux créer ? ("ctrl+c" pour terminer, ou "ok" pour quitter) : ' rolename

  # Condition pour quitter si l'utilisateur entre "ok"
  if [ "$rolename" == "ok" ]; then
    echo "Fin de la création des rôles."
    break
  fi

  # Vérifier si le nom du rôle est vide
  if [ -z "$rolename" ]; then
    echo "Le nom du rôle ne peut pas être vide. Veuillez réessayer."
    continue
  fi

  # Création de la structure de répertoires pour le rôle
  mkdir -p "roles/$rolename/{tasks,handlers,templates,files,vars,defaults,meta}"

  # Confirmer la création du rôle
  echo "Le rôle '$rolename' a été créé avec succès."
done
