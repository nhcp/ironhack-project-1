# Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "ironhack-project1-nat-eip"
  }
}

# NAT Gateway — lives in the PUBLIC subnet, gives private instances outbound internet access
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "ironhack-project1-nat"
  }

  depends_on = [aws_internet_gateway.main]
}

# Route table for the private subnet — routes internet-bound traffic through the NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "ironhack-project1-private-rt"
  }
}

# Associates the private route table with the private subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
