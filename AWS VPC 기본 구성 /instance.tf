resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "WebSG"
  }

}
resource "aws_instance" "web_server2" {
  ami               = "ami-0035ee596a0a12a7b"
  instance_type     = "t3.micro"
  subnet_id         = aws_subnet.public_subnet_1.id
  availability_zone = "ap-southeast-2a"
  security_groups   = [aws_security_group.web_sg.id]

  user_data = <<-EOF
                  #!/bin/bash
                  sudo yum update -y
                  sudo amazon-linux-extras install nginx1 -y
                  sudo systemctl start nginx
                  sudo systemctl enable nginx
                  EOF

  tags = {
    Name = "Web-Server-2"
  }
}
