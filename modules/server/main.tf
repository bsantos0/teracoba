data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_subnet" "selected_subnet" {
  id = var.subnet_id_target
}

resource "aws_key_pair" "kunci_ssh" {
  key_name   = "${var.nama_server}-key"
  public_key = file("./kunci-satu.pub")
  
}

resource "aws_security_group" "server-sg" {
  name        = "${var.nama_server}-sg"
  description = "Security group for server"
  vpc_id      = data.aws_subnet.selected_subnet.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
resource "aws_instance" "web" {
    count           = var.jumlah_instance
    ami             = data.aws_ami.ubuntu.id
    instance_type   = "t2.micro"
    subnet_id       = var.subnet_id_target
    key_name        = aws_key_pair.kunci_ssh.key_name
    security_groups = [aws_security_group.server-sg.id]
    tags = {
        Name = var.nama_server
    }
}