############################################################
#Author   : Darwin Panela                                  #
#LinkedIn : https://www.linkedin.com/in/darwinpanelacloud/ #
#github   : https://github.com/cloudhashicorp              #
############################################################


#####
#VPC#
#####

module "vpcmod" {
  source = "./vpc"

  name                  = "JitsiProj Public Subnet"
  cidr_block            = "10.0.0.0/16"
  azs                   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  pubsub                = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  routename             = "Jitsi Public Route"
  wideopensub           = "0.0.0.0/0"
  nameexternallbmeet    = "allow_443"
  descexternallbmeet    = "Allow TLS Inbound traffic"

  protocol_ingress      = "tcp"
  sgfrom_port_ingress   = 443
  sgto_port_ingress     = 443
  protocol_egress       = "-1"
  sgfrom_port_egress    = 0
  sgto_port_egress      = 0

  naclprotocol_egress   = "tcp"
  naclruleno_egress     = 200
  naclaction_egress     = "allow"
  naclfrom_port_egress  = 0
  naclto_port_egress    = 65535

  naclprotocol_ingress  = "tcp"
  naclruleno_ingress    = 100
  naclaction_ingress    = "allow"
  naclfrom_port_ingress = 443
  naclto_port_ingress   = 443




  tagspubsub = {
    Owner       = "AwGoZu"
    Environment = "Production"
    Name        = "Public Subnet"

  }


}

##############
#EC2 Instance#
##############

module "meetjvbmod" {
  source = "./meet-jvb"

  instance_type    = "t2.micro"
  azsec2           = ["us-east-1a", "us-east-1b", "us-east-1c"]
  pubsubec2        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  outjitsivpc      = module.vpcmod.outjitsivpc
  outjitsipubsub   = module.vpcmod.outjitsipubsub
  ltname           = "Jitsi_JVB_LT"
  jvbname          = "jvb_asg"
  maxasg           = 3
  minasg           = 2
  desiredcap       = 3
  hcgraceperiod    = 300
  hctype           = "ELB"
  tagresource_type = "instance"


  tags = {

    Usecase   = "Video Bridge"
    ManagedBy = "AwGoZu"
  }



}


module "albmod" {

  source = "./alb"

  lbname                     = "awgozu-jitsiapplb"
  lbtype                     = "application"
  azsec2                     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  outjitsipubsub             = module.vpcmod.outjitsipubsub
  outjitsivpc                = module.vpcmod.outjitsivpc
  outmeetinstances           = module.meetjvbmod.outmeetinstances
  enable_deletion_protection = true
  internal                   = false
  target_type                = "instance"
  tgport                     = 443
  tggroupname                = "jitsi-meet-grp"

  #Please provide your certificate and change this to HTTPS
  tggrpprotocol = "HTTP"

}






