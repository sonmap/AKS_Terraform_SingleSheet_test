locals {
  enabled_apps = {
    for k, v in var.apps : k => v
    if v.enabled
  }
}

resource "kubernetes_deployment" "this" {
  for_each = local.enabled_apps

  metadata {
    name      = each.key
    namespace = each.value.namespace

    labels = {
      app       = each.key
      app_type  = each.value.app_type
      managed_by = "terraform"
    }
  }

  spec {
    replicas = each.value.replicas

    selector {
      match_labels = {
        app = each.key
      }
    }

    template {
      metadata {
        labels = {
          app      = each.key
          app_type = each.value.app_type
        }
      }

      spec {
        container {
          name  = each.key
          image = each.value.image

          port {
            container_port = each.value.container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "this" {
  for_each = local.enabled_apps

  metadata {
    name      = each.key
    namespace = each.value.namespace

    labels = {
      app        = each.key
      managed_by = "terraform"
    }
  }

  spec {
    selector = {
      app = each.key
    }

    port {
      port        = each.value.service_port
      target_port = each.value.container_port
    }

    type = each.value.service_type
  }
}
