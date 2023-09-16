
# Création du service Kubernetes
resource "kubernetes_service" "my_reacts_app_service" {
  depends_on = [kubernetes_deployment.reacts_deployment]
  metadata {
    name      = "my-reacts-app-service"
    namespace = "patrice"
  }

  spec {
    selector = {
      app = "my-reacts-app"
    }

    port {
      port        = 80
      target_port = 80
      node_port   = 30070
    }

    type = "NodePort"
  }
}