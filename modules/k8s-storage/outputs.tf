output "pvcs" {
  value = [for pvc in kubernetes_persistent_volume_claim.this : pvc.metadata[0].name]
}
