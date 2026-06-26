module "namespaces" {
  source = "../../modules/k8s-namespace"

  namespaces = var.namespaces
}
