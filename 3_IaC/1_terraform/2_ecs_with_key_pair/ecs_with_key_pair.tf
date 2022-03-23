provider "aws" {
region="ap-south-1"
}

variable server_port {
  type    = number
  default = 8080
}

variable ssh_port {
  type    = number
  default = 22
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

resource "aws_instance" "example" {
  ami           = "ami-c790d6b6"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name = "mykey"
  user_data = <<-EOF
        #!/bin/bash
        echo 'hello world' > index.html
        nohup busybox httpd -f -p ${var.server_port} & 
        EOF
   tags =  {
     Name = "terraform-example"
        }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "aws_instance" {
value = aws_instance.example
}
