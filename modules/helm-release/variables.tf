variable "helm_releases" {
  description = "Helm release map generated from the single-sheet design."
  type = map(object({
    enabled      = bool
    namespace    = string
    repository   = string
    chart        = string
    service_type = string
  }))
  default = {}
}
