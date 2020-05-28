variable "outjitsipubsub" {}
variable "outjitsivpc" {}
variable "outmeetinstances" {}

variable "lbname" {

  description = "Application Load Balancer url name"
  type        = string
}

variable "lbtype" {

  description = "Application/Network/Classic Type of Load Balancer"
  type        = string
}

variable "internal" {

  description = "A value of true or false for load balancer"
  type        = string
}

variable "target_type" {

  type = string
}

variable "tgport" {

  type = number
}

variable "tggroupname" {

  type = string
}


variable "tggrpprotocol" {

  type = string
}

variable "azsec2" {

  type    = list(string)
  default = []
}

variable "enable_deletion_protection" {

  type = string
}


