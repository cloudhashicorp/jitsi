variable "cidr_block" {}


variable "vpc_name" {

  default = "Jitsi VPC"

}


variable "igw_name" {

  default = "jitsiigw"
}

variable "pubsub" {

  description = "IPv4 Public Subnet in AZ"
  type        = list(string)
  default     = []

}

variable "name" {

  description = "Name to be used to identify the resource"
  type        = string
  default     = ""
}

variable "tagspubsub" {

  description = "A map of tags for resources"
  type        = map(string)
  default     = {}
}

variable "azs" {

  description = "A list of AZs or ids in the region"
  type        = list(string)
  default     = []
}

variable "routename" {

  description = "Name of the Route Table"
  type        = string
}

variable "wideopensub" {

  description = "CIDR Range for Anywhere"
  type        = string

}

variable "nameexternallbmeet" {

  description = "Name of the External/Internet Front Load Balancer"
  type        = string
}

variable "descexternallbmeet" {

  description = "Description for External Load Balancer for Meet"
  type        = string
}

variable "sgfrom_port_ingress" {

  type = number
}

variable "sgto_port_ingress" {

  type = number
}

variable "sgfrom_port_egress" {

  type = number
}


variable "sgto_port_egress" {

  type = number
}

variable "protocol_ingress" {

  type = string
}

variable "protocol_egress" {

  type = number
}


variable "naclprotocol_egress" {

  type = string
}


variable "naclruleno_egress" {

  type = number
}

variable "naclaction_egress" {

  type = string
}

variable "naclfrom_port_egress" {

  type = number
}

variable "naclto_port_egress" {

  type = number
}

variable "naclprotocol_ingress" {

  type = string
}

variable "naclruleno_ingress" {

  type = number
}

variable "naclaction_ingress" {

  type = string
}

variable "naclfrom_port_ingress" {

  type = number
}

variable "naclto_port_ingress" {

  type = number
}



