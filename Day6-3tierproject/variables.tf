variable "vpc-cidr" {
  description = "given cidr rande here"
  type        = string
  default     = "10.0.0.0/16"

}

variable "rds-username" {
  description = "given rds username"
  type        = string
  default     = ""

}

variable "rds-password" {
  description = "given rds password"
  type        = string
  default     = ""

}

