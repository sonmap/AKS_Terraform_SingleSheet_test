resource "kubernetes_persistent_volume_claim" "this" {
  for_each = {
    for k, v in var.persistent_volume_claims : k => v
    if v.enabled
  }

  metadata {
    name      = each.key
    namespace = each.value.namespace

    labels = {
      managed_by = "terraform"
    }
  }

  spec {
    access_modes       = each.value.access_modes
    storage_class_name = each.value.storage_class

    resources {
      requests = {
        storage = each.value.size
      }
    }
  }
}
