# Create a new VPC
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.20.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "test-vpc"
  }
}

# Create two public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.20.32.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.20.33.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "public-subnet-2"
  }
}

# Create two private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.20.30.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.20.31.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "private-subnet-2"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test-igw"
  }
}

# Attach the internet gateway to the VPC
resource "aws_vpc_attachment" "test_vpc_igw_attachment" {
  vpc_id = aws_vpc.test_vpc.id
  internet_gateway_id = aws_internet_gateway.test_igw.id
}

# Create a new route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}
