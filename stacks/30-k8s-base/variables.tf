variable "kubeconfig_path" {
  description = "Path to kubeconfig. Example: ~/.kube/config"
  type        = string
  default     = "~/.kube/config"
}

variable "namespaces" {
  description = "Namespace map generated from single-sheet design."
  type = map(object({
    enabled = bool
    name    = string
  }))
  default = {}
}
