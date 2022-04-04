# NAT Gateway
# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
resource "aws_nat_gateway" "nat_1a" {
  subnet_id     = "${aws_subnet.public_1a.id}" # NAT Gatewayを配置するSubnetを指定
  allocation_id = "${aws_eip.nat_1a.id}"       # 紐付けるElasti IP

  tags = {
    Name = "handson-1a"
  }
}
