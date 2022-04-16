resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_example.id
  instance_id = aws_instance.example.id
}

resource "aws_ebs_volume" "ebs_example" {
  availability_zone = "ap-south-1a"
  size              = 100
}
