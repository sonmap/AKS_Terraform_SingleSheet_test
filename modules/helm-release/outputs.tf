output "argocd_release" {
  value = try(helm_release.argocd[0].name, null)
}

output "jenkins_release" {
  value = try(helm_release.jenkins[0].name, null)
}
