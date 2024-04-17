# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "tf-lab-vpc"
  }
}

# Public Subnet 생성
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "public-subnet-2"
  }
}

# Internet Gateway 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# Public Route Table 생성 및 연결
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_rta_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_rta_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Subnet 생성
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.128.0/22"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.132.0/22"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "private-subnet-2"
  }
}

# NAT Gateway 생성 및 EIP 할당
resource "aws_eip" "nat_eip_1" {
  vpc = true
  tags = {
    Name = "nat-eip-1"
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "nat-gateway-1"
  }
}

resource "aws_eip" "nat_eip_2" {
  vpc = true
  tags = {
    Name = "nat-eip-2"
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id
  tags = {
    Name = "nat-gateway-2"
  }
}

# Private Route Table 생성 및 NAT Gateway 연결
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }
  tags = {
    Name = "private-route-table-1"
  }
}

resource "aws_route_table_association" "private_rta_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }
  tags = {
    Name = "private-route-table-2"
  }
}

resource "aws_route_table_association" "private_rta_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}
