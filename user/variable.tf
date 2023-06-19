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

variable "aws_access_key" {
  description = "AWS access key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
}