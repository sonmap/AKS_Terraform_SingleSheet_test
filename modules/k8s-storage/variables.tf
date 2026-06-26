variable "persistent_volume_claims" {
  description = "PVC map generated from the single-sheet design."
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
