# Projet Ansible - Déploiement de GitLab

## Description du projet

Ce projet a pour objectif d'automatiser le déploiement d'un serveur GitLab ainsi que d'une base de données PostgreSQL en utilisant **Ansible**. L'objectif final est de simplifier le déploiement via un simple "push button", où Ansible gère toutes les étapes nécessaires.

### Fonctionnalités principales

- **Déploiement automatique de GitLab** via Ansible.
- **Installation et configuration de PostgreSQL** pour héberger les données de GitLab.
- **Configuration automatisée de GitLab** (URL, base de données, etc.).
- Utilisation des rôles Ansible pour structurer les tâches.

---

## Prérequis

- **Machine virtuelle pour GitLab** (Ubuntu Server recommandé).
- **Machine de contrôle Ansible** (peut être la même ou différente de la machine cible).
- **SSH configuré** entre la machine de contrôle et la machine cible.
- **Ansible installé** sur la machine de contrôle.

---

## Architecture du projet

Le projet est organisé autour de plusieurs **rôles Ansible**, chacun étant responsable d'une partie spécifique du déploiement.

### Rôles Ansible

1. **Rôle `common`** :

   - Ce rôle installe les dépendances communes nécessaires au bon fonctionnement des autres rôles.
   - Il contient des configurations globales qui seront appliquées sur toutes les machines de l'inventaire.

2. **Rôle `bdd`** (Base de données PostgreSQL) :

   - Ce rôle installe et configure PostgreSQL.
   - Crée les bases de données et les utilisateurs associés.
   - Modifie les fichiers de configuration comme `pg_hba.conf` pour permettre la connexion réseau et l'authentification par mot de passe.

3. **Rôle `gitlab`** :
   - Ce rôle installe GitLab à partir des paquets fournis par GitLab.
   - Configure GitLab (URL d'accès, paramètres de la base de données, etc.).
   - Effectue la configuration initiale de GitLab via la commande `gitlab-ctl reconfigure`.

---

## Déploiement de GitLab avec Ansible

### 1. **Installation de GitLab**

Le rôle `gitlab` commence par installer GitLab en ajoutant le dépôt GitLab et la clé GPG nécessaires. Ensuite, il installe le paquet GitLab et exécute `gitlab-ctl reconfigure` pour finaliser l'installation et appliquer la configuration par défaut.

- **Modules Ansible utilisés** : `apt`, `command`

### 2. **Configuration de GitLab**

La configuration de GitLab est automatisée en modifiant le fichier de configuration `/etc/gitlab/gitlab.rb`. Des variables Ansible sont utilisées pour personnaliser l'URL d'accès, la configuration de la base de données, et d'autres paramètres essentiels.

- **Modules Ansible utilisés** : `lineinfile`, `template`

### 3. **Gestion de PostgreSQL**

Le rôle `bdd` installe et configure PostgreSQL. Il crée plusieurs bases de données (par exemple, `all`, `dev`, `stage`, `prod`) et des utilisateurs associés avec les privilèges nécessaires. Ce rôle modifie également le fichier `pg_hba.conf` pour permettre les connexions distantes et utilise des expressions régulières pour s'assurer que les modifications sont effectuées correctement.

- **Modules Ansible utilisés** : `postgresql_user`, `postgresql_db`, `lineinfile`

### 4. **Gestion des fichiers de configuration**

Des fichiers de configuration spécifiques sont modifiés pour garantir la bonne configuration de GitLab et PostgreSQL. Par exemple, le fichier `pg_hba.conf` est ajusté pour permettre l'accès depuis n'importe quelle adresse IP (au lieu de limiter l'accès à `127.0.0.1`), et l'authentification par mot de passe est activée.

- **Modules Ansible utilisés** : `lineinfile`, `replace`

---

## Modules Ansible principaux utilisés

- **`apt`** : Pour l'installation des paquets (GitLab, PostgreSQL, etc.).
- **`postgresql_user`** : Pour gérer les utilisateurs PostgreSQL.
- **`postgresql_db`** : Pour créer et gérer les bases de données PostgreSQL.
- **`lineinfile`** : Pour modifier les fichiers de configuration en fonction des expressions régulières.
- **`command`** : Pour exécuter des commandes système, comme `gitlab-ctl reconfigure`.

---

## Structure des fichiers

Le projet utilise des rôles Ansible pour organiser le code. Voici la structure des répertoires :

```
roles/
├── common/
│   ├── tasks/
│   ├── handlers/
│   ├── templates/
│   └── vars/
├── bdd/
│   ├── tasks/
│   ├── handlers/
│   ├── templates/
│   └── vars/
└── gitlab/
    ├── tasks/
    ├── handlers/
    ├── templates/
    └── vars/
```

Chaque rôle contient des sous-dossiers pour :

- **`tasks/`** : Les tâches à exécuter (par exemple, installation des paquets).
- **`handlers/`** : Les actions à effectuer en réponse à un changement (par exemple, redémarrer un service).
- **`templates/`** : Les fichiers de configuration à déployer sur la machine cible.
- **`vars/`** : Les variables utilisées pour la configuration.

---

## Exécution du projet

1. **Créer une machine virtuelle pour GitLab** : Utilisez une VM Ubuntu ou Debian.
2. **Configurer l'accès SSH** entre votre machine de contrôle Ansible et la machine cible.
3. **Modifier le fichier d'inventaire** pour ajouter les hôtes cibles.
4. **Exécuter le playbook Ansible** pour déployer GitLab et PostgreSQL :
   ```bash
   ansible-playbook -i inventory/hosts site.yml
   ```

Cela lancera le déploiement automatique de GitLab avec la base de données PostgreSQL.

---

## Conclusion

Ce projet permet de déployer et de configurer GitLab de manière automatisée en utilisant Ansible. Grâce à la modularité des rôles, le projet peut facilement être étendu ou modifié pour s'adapter à des besoins spécifiques. L'utilisation de variables et de modules comme `apt`, `postgresql_user`, et `lineinfile` garantit un déploiement fiable et reproductible.
"# AnsibleProjectM1" 
