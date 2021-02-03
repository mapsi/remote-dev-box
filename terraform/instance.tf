resource "aws_security_group" "remote-dev-box-sg" {
  name        = "remote-dev-box-sg"
  description = "Remote dev box security group"

  dynamic "ingress" {
    for_each = var.open_ports
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "remote-dev-box" {
  ami           = var.instance.ami
  instance_type = var.instance.type
  key_name      = var.ssh_key_name

  root_block_device {
    volume_size = 20
  }

  vpc_security_group_ids = [aws_security_group.remote-dev-box-sg.id]
}

resource "aws_eip" "remote-dev-box-eip" {
  instance = aws_instance.remote-dev-box.id
  vpc      = true
}