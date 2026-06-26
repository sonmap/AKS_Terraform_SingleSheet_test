variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}

variable "persistent_volume_claims" {
  type = map(object({
    enabled       = bool
    namespace     = string
    storage_class = string
    size          = string
    access_modes  = list(string)
    mount_path    = string
  }))
  default = {}
}
