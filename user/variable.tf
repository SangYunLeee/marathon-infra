variable "public_sg_name" {
  description = "SG for public"
  type        = string
  default     = "TRF_SG_PUBLIC"
}

variable "private_sg_name" {
  description = "SG for private"
  type        = string
  default     = "TRF_SG_PRIVATE"
}

variable "AWS_ACCESS_KEY" {
  description = "AWS access key ID"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret access key"
  type        = string
}