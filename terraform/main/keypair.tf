# Generate a fresh SSH key pair for this project
resource "tls_private_key" "project_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload the public key to AWS so EC2 instances can use it
resource "aws_key_pair" "project_key" {
  key_name   = "ironhack-project1-key"
  public_key = tls_private_key.project_key.public_key_openssh
}

# Save the private key locally so we can actually SSH in
resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.project_key.private_key_pem
  filename        = "${path.module}/ironhack-project1-key.pem"
  file_permission = "0400"
}
