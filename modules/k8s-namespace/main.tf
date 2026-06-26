resource "kubernetes_namespace" "this" {
  for_each = {
    for k, v in var.namespaces : k => v
    if v.enabled
  }

  metadata {
    name = each.value.name

    labels = {
      managed_by = "terraform"
    }
  }
}
