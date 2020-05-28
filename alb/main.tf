resource "aws_lb" "jitsiapplb" {

  name                       = var.lbname
  internal                   = var.internal
  load_balancer_type         = var.lbtype
  subnets                    = var.outjitsipubsub
  enable_deletion_protection = var.enable_deletion_protection


}

resource "aws_lb_target_group" "jitsimeetgrp" {

  name        = var.tggroupname
  port        = var.tgport
  protocol    = var.tggrpprotocol
  vpc_id      = var.outjitsivpc
  target_type = var.target_type
}

resource "aws_lb_target_group_attachment" "jitsimeetgrpattach" {

  count            = length(var.azsec2)
  target_group_arn = aws_lb_target_group.jitsimeetgrp.arn
  target_id        = var.outmeetinstances[count.index]
  port             = var.tgport

}


resource "aws_lb_listener" "awgozulbport" {

  load_balancer_arn = aws_lb.jitsiapplb.arn
  port              = var.tgport
  protocol          = var.tggrpprotocol

  default_action {

    type             = "forward"
    target_group_arn = aws_lb_target_group.jitsimeetgrp.arn
  }
}