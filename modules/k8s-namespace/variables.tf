variable "namespaces" {
  description = "Namespace map generated from the single-sheet design."
  type = map(object({
    enabled = bool
    name    = string
  }))
  default = {}
}
