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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJE3IFld1B4Mu+7SGNQl/oc6yXDnr1YW2bPPlxha5O1oDk6c9aTHqqxcCROBIZRJESj31H4kXPIiDch3Bs3qsOHhDzao6vqddTDq6ONeykmKZH0MpVyowWjMlYBoi0kYX8lLxBIk+dX5GNd2zr91TEuJHPuQhgfsJaaQqKtPMrEu2KaI/Yel2qs/oZ0qif/SfFxaj6tQU3FcF+E3xYT+ww83fV93fsAh55y6cKmaWhlaWGu1ixrjdONgKZvtXJZnr6W4sRxo1ygtr8yS/Zl74ooWqp6gS9DRM0LY8rWPpEtxT8fwjt3ZrSmbsGpN0xD56Cfw66jn3cniOVH/BTNf/wkmtg7NutgFOa+592llXyJGPFHJkjzed3RfQwMZ+HdgtZZeAHwxKE8fWzVi9pOr1Ske7RwXGbEz9RC2mt3ITvFXX/unUf3Ow8LlOWgkbxe9q4OSWFMuuCLGOBO4D9Hpm8b20nrZhMBKIzy3BCdq5//ZLt85fiti0rYbUChiKu1pk= 29371962@qq.com"
}

resource "aws_instance" "example" {
  ami           = "ami-08ee6644906ff4d6c"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  subnet_id = "${aws_subnet.public_1a.id}"
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
  vpc_id = "${aws_vpc.main.id}"
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
