variable "app_name" {
  default = "test-app"
}

variable "region" {
  default = "eu-west-1"
}

variable "vpc_id" {
  default = "vpc-123456789"
}

variable "private_subnet_ids" {
  default = ["subnet-123456789", "subnet-123456780"]
}

variable "public_subnet_ids" {
  default = ["subnet-123456781", "subnet-123456782"]
}

variable "ssl_certificate_arn" {
  default = "arn:aws:acm:eu-west-1:123456789:certificate/abcdef123456"
}

variable "domain_name" {
  default = "test.wowcher.co.uk"
}

variable "db_username" {
  default = "my_username"
}

variable "db_password" {
  default = "my_password"
}