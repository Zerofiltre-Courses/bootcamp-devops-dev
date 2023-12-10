# Créer 03 instances EC2 sur AWS à partir de terraform

Les sources (codes et configurations) des projets 03 EC2 **"IAC".**

## Arborescence des projets
**`créer le fichier export-vars.sh dans le dossier terraform et y ajouter le contenu suivant `**
```
#!/bin/bash
export AWS_ACCESS_KEY_ID=<YOUR_ACCES_KEY>
export AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_KEY>

```
## Création des instances EC2
**`$ ./buid-3-ec2.sh `**

## Destruction des instances EC2
**`$ ./destroy-3-ec2.sh `**
