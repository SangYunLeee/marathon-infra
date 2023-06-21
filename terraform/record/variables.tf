variable "ECR_IMAGE_URL" {
  description = "record url"
  type        = string
  default     = "648098991845.dkr.ecr.ap-northeast-2.amazonaws.com/race:0.7"
}

variable "DB_HOST" {
  type        = string
  default     = "for-tf-race-record.c8xl53x8kbuy.ap-northeast-2.rds.amazonaws.com"
}
variable "DB_USERNAME" {
  type        = string
  default     = "admin"
}
variable "DB_PASSWORD" {
  type        = string
}
variable "DB_DATABASE" {
  type        = string
  default     = "race"
}

variable "DB_PORT" {
  type        = number
  default     = 3306
}

variable "QUEUE_URL" {
  description = "QUEUE_URL"
  type        = string
  default     = "https://sqs.ap-northeast-2.amazonaws.com/648098991845/race-point-sqs"
}
