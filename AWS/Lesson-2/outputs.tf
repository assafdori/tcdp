output "instance_ip" {
  value = aws_instance.technion-demo.public_ip
}

output "private_key" {
  value = tls_private_key.technion-demo-key.private_key_pem
  sensitive = true
}
