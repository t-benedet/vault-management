variable "vault_url" {
  type        = string
  default     = ""
  description = "Vault address."

}

variable "vault_role" {
  type        = string
  default     = ""
  description = "Vault role."
}

variable "vault_ns" {
  type        = string
  default     = ""
  description = "Vault namespace."
}

variable "auth_jwt" {
  type        = string
  default     = ""
  description = "Auth jwt token."
}
