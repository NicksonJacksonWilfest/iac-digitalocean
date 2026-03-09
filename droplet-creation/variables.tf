variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Path to your public SSH key"
  type        = string
  default     = "~/.ssh/do_terraform_key.pub"
}

variable "ssh_private_key_path" {
  description = "Path to your private SSH key"
  type        = string
  default     = "~/.ssh/do_terraform_key"
}
