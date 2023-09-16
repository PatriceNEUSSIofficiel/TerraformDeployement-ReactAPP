# Définition du fournisseur Kubernetes

terraform {
  required_providers {
    kubernetes = {
      source = "kubernetes"
    }

    docker = {

      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  backend "kubernetes" {
    config_path   = "~/.kube/config"
    secret_suffix = "reacts"
    namespace     = "patrice"


  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"


}

# Création de la ressource Docker image à partir du Dockerfile existant

resource "docker_image" "my_reacts_app" {
  
  name = "my-react-image"
  build { # build docker
    # Chemin vers le répertoire contenant votre projet reacts
    context    = "./Dockerfile" # context
    dockerfile = "./Dockerfile" # Chemin vers votre fichier Dockerfile existant
  } # end
  keep_locally = true # keep
} 

# Création du déploiement Kubernetes


resource "kubernetes_deployment" "reacts_deployment" {
  metadata {
    name = "my-reacts-app-deployment"

    namespace = "patrice"

    labels = {
      "app" = "my-reacts-app"

    }

  }

  spec {

    selector {

      match_labels = {
        "app" = "my-reacts-app"

      }

    }

    template {
      metadata {
        namespace = "patrice"
        labels = {
          "app" = "my-reacts-app"
        }
      }

      spec {
        container {
          name  = "my-reacts-app-container"
          image = "cherif1/my-react-app"

          # Options facultatives pour personnaliser le conteneur
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

