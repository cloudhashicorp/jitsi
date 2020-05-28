output "outjitsivpc" {

  description = "ID of the VPC created"
  value       = aws_vpc.vpcjitsi.id
}

output "outjitsipubsub" {

  description = "ID of each Public subnet"
  value       = aws_subnet.jitsipubsub.*.id


}




