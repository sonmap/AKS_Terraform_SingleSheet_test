module "storage" {
  source = "../../modules/k8s-storage"

  persistent_volume_claims = var.persistent_volume_claims
}
