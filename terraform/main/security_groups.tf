# Security Group for Instance A (Vote + Result) — also acts as the bastion host
resource "aws_security_group" "frontend" {
  name        = "ironhack-project1-frontend-sg"
  description = "Allow HTTP, and SSH from the internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere (for bastion access)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Vote app"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Result app"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ironhack-project1-frontend-sg"
  }
}

# Security Group for Instance B (Redis + Worker)
resource "aws_security_group" "backend" {
  name        = "ironhack-project1-backend-sg"
  description = "Allow Redis from frontend, SSH from frontend only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH from frontend (bastion) only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  ingress {
    description     = "Redis from frontend (vote app)"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ironhack-project1-backend-sg"
  }
}

# Security Group for Instance C (Postgres)
resource "aws_security_group" "database" {
  name        = "ironhack-project1-database-sg"
  description = "Allow Postgres from backend (worker), SSH from frontend only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH from frontend (bastion) only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  ingress {
    description     = "Postgres from backend (worker)"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  ingress {
    description     = "Postgres from frontend (result app)"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ironhack-project1-database-sg"
  }
}
