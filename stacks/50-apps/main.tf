module "apps" {
  source = "../../modules/k8s-app"

  apps = var.apps
}
