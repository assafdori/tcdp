output "public_ip" {
  value = aws_instance.technion-instance-public.public_ip
}

output "private_ip" {
  value = aws_instance.technion-instance-private.private_ip
}
