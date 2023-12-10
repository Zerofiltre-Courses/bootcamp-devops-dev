# I - Terraform & AWS CLI Installation

## Étape-01: Introduction
- Installer  de la CLI Terraform
- Installer de la CLI AWS
- Installer l'éditeur VS Code
- Installer le plugin HashiCorp Terraform pour VS Code


## Étape-02: MACOS: Terraform Install
- [Télécharger Terraform MAC](https://www.terraform.io/downloads.html)
- [Install CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Décompressez le package
```
# Copier le fichier zip binaire dans un dossier
mkdir /Users/<Votre-utilisateur>/Documents/terraform-install
COPY Package to "terraform-install" folder

# Décompresser
unzip <NOM DU PAQUET>
unzip terraform_0.14.3_darwin_amd64.zip

# Copier le binaire terraform dans /usr/local/bin
echo $PATH
mv terraform /usr/local/bin

# Vérifier la version
terraform version

# Désinstaller Terraform (NON REQUIS)
rm -rf /usr/local/bin/terraform
``` 

## Étape-03: MACOS : IDE pour Terraform - Editeur de code VS
- [Éditeur de code de Microsoft Visual Studio](https://code.visualstudio.com/download)
- [Hashicorp Terraform Plugin pour VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)


### Étape-04: MACOS: Install AWS CLI
- [AWS CLI Install](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [Installation AWS CLI - MAC](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-install-cmd)

```
# Installer AWS CLI V2
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
which aws
aws --version

# Désinstaller AWS CLI V2 (NON REQUIS)
which aws
ls -l /usr/local/bin/aws
sudo rm /usr/local/bin/aws
sudo rm /usr/local/bin/aws_completer
sudo rm -rf /usr/local/aws-cli
```


## Étape-05: MACOS: Configurer les informations d'identification AWS 
- **Pre-requisite:** Doit avoir un compte AWS.
  - [Créer un compte AWS](https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=header_signup&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start)
- Générer les justificatifs de sécurité à l'aide de la console de gestion AWS
  - Allez dans Services -> IAM -> Users -> "Your-Admin-User" -> Security Credentials -> Create Access Key
- Configurer les informations d'identification AWS à l'aide du terminal SSH sur votre bureau local
```
# Configurer les informations d'identification AWS en ligne de commande
$ aws configure
AWS Access Key ID [None]: YOUR_ACCESS_KEY
AWS Secret Access Key [None]: YOUR_SECRET_ACCESS_KEY
Default region name [None]: eu-west-3
Default output format [None]: json

# Vérifier si nous pouvons lister les buckets S3
aws s3 ls
```
- Vérifier le profil d'authentification AWS
```
cat $HOME/.aws/credentials 
```

## Étape-06: WindowsOS: Installation de Terraform & AWS CLI
- [Télécharger Terraform](https://www.terraform.io/downloads.html)
- [Installation de la  CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Décompressez le paquet
- Créez un nouveau dossier `terraform-bins`.
- Copier le fichier `terraform.exe` dans le dossier `terraform-bins`.
- Définir le PATH dans Windows  
- Installation de la [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

## Étape-07: LinuxOS: Installation de Terraform & AWS CLI
- [Télécharger Terraform](https://www.terraform.io/downloads.html)
- [Linux OS - installation Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)


# II- Notions de base sur la commande Terraform

## Étape-01 : Introduction
- Comprendre les commandes de base de Terraform
  - terraform init
  - terraform validate
  - terraform plan
  - terraform apply
  - terraform destroy      

## Étape-02 : Examiner le manifeste terraform pour l'instance EC2
- **Pre-Conditions-1:** Assurez-vous que vous avez **default-vpc** dans cette région respective.
- **Pré-Conditions-2:** Assurez-vous que l'AMI que vous provisionnez existe dans cette région, si ce n'est pas le cas, mettez à jour l'identifiant de l'AMI. 
- **Pré-Conditions 3:** Vérifier vos identifiants AWS dans **$HOME/.aws/credentials**.
```t
# Bloc de paramètres Terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"# Facultatif mais recommandé en production
    }
  }
  required_version = ">= 1.2.0"

}

# Bloc fournisseur
provider "aws" {
  profile = "default" # Profil d'informations d'identification AWS configuré sur votre terminal local $HOME/.aws/credentials
  region = "eu-west-3"
}

# Bloc de ressources
resource "aws_instance" "app_server" {
  ami           = "ami-05b457b541faec0ca"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

```

## Étape-03 : Commandes de base de Terraform
```t
# Initialisation de Terraform toutefois en etant dans le repertoire contenant le fichier main.tf
terraform init

# Terraform Validate
terraform validate

# Terraform plan pour vérifier ce qu'il va créer / mettre à jour / détruire)
terraform plan

# Terraform Apply pour créer une instance EC2
terraform apply 
```

## Étape-04 : Vérifier l'instance EC2 dans la console de gestion AWS
- Aller dans AWS Management Console -> Services -> EC2
- Vérifier l'instance EC2 nouvellement créée

## Étape-05 : Détruire l'infrastructure
```t
# Détruire l'instance EC2
terraform destroy

# Supprimer les fichiers Terraform 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Étape-08 : Conclusion
- Réitérer ce que nous avons appris dans cette section
- Apprentissage des commandes importantes de Terraform
  - terraform init
  - terraform validate
  - terraform plan
  - terraform apply
  - terraform destroy  