#####################
#Latest Ubuntu Image#
#####################

data "aws_ami" "ubuntuimage" {

  most_recent = true

  filter {

    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {

    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


############
#Jitsi Meet#
############

resource "aws_instance" "meetinstances" {

  count             = length(var.azsec2)
  ami               = data.aws_ami.ubuntuimage.id
  instance_type     = var.instance_type
  availability_zone = var.azsec2[count.index]
  subnet_id         = var.outjitsipubsub[count.index]

}



#######################################
#Jitsi Video Bridge Auto Scaling Group#
#######################################

resource "aws_launch_template" "jitsilt" {

  name          = var.ltname
  image_id      = data.aws_ami.ubuntuimage.id
  instance_type = var.instance_type

  tag_specifications {

    resource_type = var.tagresource_type
    tags          = var.tags
  }

}


resource "aws_autoscaling_group" "jitsivideobridge" {

  name                      = var.jvbname
  max_size                  = var.maxasg
  min_size                  = var.minasg
  desired_capacity          = var.desiredcap
  vpc_zone_identifier       = var.outjitsipubsub
  health_check_grace_period = var.hcgraceperiod
  health_check_type         = var.hctype

  launch_template {
    id      = aws_launch_template.jitsilt.id
    version = "$Latest"
  }



}



