variable "instance_type" {

  type = string
}

variable "azsec2" {

  type    = list(string)
  default = []
}

variable "outjitsipubsub" {}
variable "outjitsivpc" {}

variable "pubsubec2" {

  type    = list(string)
  default = []
}

variable "ltname" {

  type = string

}

variable "jvbname" {

  type = string
}

variable "maxasg" {

  type = number
}

variable "minasg" {

  type = number
}

variable "desiredcap" {

  type = number
}

variable "hcgraceperiod" {

  type = number
}

variable "hctype" {

  type = string
}

variable "tagresource_type" {

  description = "Tag to be used in the resource, either volume or instance"
  type        = string

}

variable "tags" {

  type    = map(string)
  default = {}

}





