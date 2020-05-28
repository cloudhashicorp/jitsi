output "outmeetinstances" {

  description = "EC2 for Meet Server"
  value       = aws_instance.meetinstances.*.id


}