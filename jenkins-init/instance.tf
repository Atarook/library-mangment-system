resource "aws_instance" "jenkins-instance" {
  ami           = "ami-03cc8375791cb8bcf"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.jenkins_public_subnet.id
  user_data     = file("init.sh")

  key_name = "team4-jenkins-key-pair"

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]

  tags = {
    Name = "team4-jenkins-instance"
  }
}


