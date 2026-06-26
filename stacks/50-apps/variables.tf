variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}

variable "apps" {
  type = map(object({
    enabled        = bool
    app_type       = string
    namespace      = string
    image          = string
    container_port = number
    replicas       = number
    service_type   = string
    service_port   = number
  }))
  default = {}
}
