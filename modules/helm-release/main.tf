locals {
  enabled_helm_releases = {
    for k, v in var.helm_releases : k => v
    if v.enabled
  }
}

resource "helm_release" "argocd" {
  count = contains(keys(local.enabled_helm_releases), "argocd") ? 1 : 0

  name             = "argocd"
  namespace        = local.enabled_helm_releases["argocd"].namespace
  repository       = local.enabled_helm_releases["argocd"].repository
  chart            = local.enabled_helm_releases["argocd"].chart
  create_namespace = false

  set {
    name  = "server.service.type"
    value = local.enabled_helm_releases["argocd"].service_type
  }
}

resource "helm_release" "jenkins" {
  count = contains(keys(local.enabled_helm_releases), "jenkins") ? 1 : 0

  name             = "jenkins"
  namespace        = local.enabled_helm_releases["jenkins"].namespace
  repository       = local.enabled_helm_releases["jenkins"].repository
  chart            = local.enabled_helm_releases["jenkins"].chart
  create_namespace = false

  set {
    name  = "controller.serviceType"
    value = local.enabled_helm_releases["jenkins"].service_type
  }
}
