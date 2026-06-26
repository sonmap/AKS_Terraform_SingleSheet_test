output "deployments" {
  value = [for d in kubernetes_deployment.this : d.metadata[0].name]
}

output "services" {
  value = [for s in kubernetes_service.this : s.metadata[0].name]
}
