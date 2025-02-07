resource "kubernetes_deployment" "atlantis" {
     metadata {
         name = "atlantis"
          labels = {
             app = "atlantis"
              }
  }
spec {
     replicas = 1
     selector {
         match_labels = {
            app = "atlantis"
            }
    }
    template {
        metadata {
             labels = {
                 app = "atlantis"
                 }
      }
       spec {
         container {
            name  = "atlantis"
             image = "runatlantis/atlantis:latest" 
              ports {
                container_port = 4141
          }
          env {
            name  = "ATLANTIS_SECRET"
            value = "-secret-key"
             }
             env {
                name  = "ATLANTIS_URL"
                  value = "http://atlantis.domain.com"
                   }
        }
      }
    }
  }
}
resource "kubernetes_service" "atlantis" {
    metadata {
        name = "atlantis"
        }
         spec {
            selector = {
                app = "atlantis"
                 }
                 port {
                    port        = 80
                    target_port = 4141
                    }
    type = "LoadBalancer"
  }
}