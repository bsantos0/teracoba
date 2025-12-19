#1 Membuat VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_vpc
    tags = {
        Name = "${var.project_name}-vpc"
    }
}

#2. Membuat Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id 
  tags = {
      Name = "${var.project_name}-igw"
  }
}

#3. Membuat Subnet Publik
resource "aws_subnet" "my_subnet_public" {
    vpc_id                   = aws_vpc.my_vpc.id
    cidr_block               = cidrsubnet(var.cidr_vpc,8,1)
    map_public_ip_on_launch  = true
    availability_zone        = "ap-southeast-1a"
    tags = {
        Name = "${var.project_name}-public-subnet"
    }
}

#3a. Membuat Subnet Privat
resource "aws_subnet" "my_subnet_private_a" {
    vpc_id                   = aws_vpc.my_vpc.id
    cidr_block               = cidrsubnet(var.cidr_vpc,8,2)
    map_public_ip_on_launch  = false
    availability_zone        = "ap-southeast-1a"
    tags = {
        Name = "${var.project_name}-private-subnet-a"
    }
}
resource "aws_subnet" "my_subnet_private_b" {
    vpc_id                   = aws_vpc.my_vpc.id
    cidr_block               = cidrsubnet(var.cidr_vpc,8,3)
    map_public_ip_on_launch  = false
    availability_zone        = "ap-southeast-1b"
    tags = {
        Name = "${var.project_name}-private-subnet-b"
    }
}

#4. Membuat Route Table Publik
resource "aws_route_table" "my_public_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "${var.project_name}-public-rt"
    }
}

resource "aws_route_table_association" "public_subnet_assoc" {
    subnet_id      = aws_subnet.my_subnet_public.id
    route_table_id = aws_route_table.my_public_rt.id
}
