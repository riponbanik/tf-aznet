
variable "tags" {
  description = "Resource tags"
  type        = map(any)
  default = {
    "Environment" : "Sandbox"
  }
}
