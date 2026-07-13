# Dynamically fetch the latest Ubuntu 22.04 AMI for us-east-1 via SSM
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# Instance A — Public subnet: Vote + Result (also acts as bastion)
resource "aws_instance" "frontend" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.frontend.id]
  key_name                    = aws_key_pair.project_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "ironhack-project1-frontend"
  }
}

# Instance B — Private subnet: Redis + Worker
resource "aws_instance" "backend" {
  ami                    = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.backend.id]
  key_name               = aws_key_pair.project_key.key_name

  tags = {
    Name = "ironhack-project1-backend"
  }
}

# Instance C — Private subnet: Postgres
resource "aws_instance" "database" {
  ami                    = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.database.id]
  key_name               = aws_key_pair.project_key.key_name

  tags = {
    Name = "ironhack-project1-database"
  }
}
