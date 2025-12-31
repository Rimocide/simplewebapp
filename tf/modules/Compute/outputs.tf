output "public_ec2_ip" {
  value = aws_instance.public.public_ip
}

output "private_ec2_ip" {
  value = aws_instance.private.private_ip
}

output "ssh_private_key" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}
