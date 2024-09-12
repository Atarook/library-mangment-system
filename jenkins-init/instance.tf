resource "aws_instance" "jenkins-instance" {
  ami           = "ami-03cc8375791cb8bcf"
  instance_type = "t2.xlarge"
  subnet_id     = aws_subnet.jenkins_public_subnet.id
  user_data     = file("init.sh")

  key_name = "team4-jenkins-key-pair"

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }


  tags = {
    Name = "team4-jenkins-instance"
  }
}


