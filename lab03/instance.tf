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
resource "aws_launch_template" "web_server_lt" {
  name_prefix   = "web-server-lt-"
  image_id      = "ami-0035ee596a0a12a7b"
  instance_type = "t3.micro"

  user_data = base64encode(<<-EOF
                    #!/bin/bash
                    sudo yum update -y
                    sudo amazon-linux-extras install nginx1 -y
                    sudo systemctl start nginx
                    sudo systemctl enable nginx
                    EOF
  )
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Web-Server"
    }
  }
}


resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  launch_template {
    id      = aws_launch_template.web_server_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Web-Server-ASG"
    propagate_at_launch = true
  }
}


# resource "aws_instance" "web_server1" {
#   ami               = "ami-0035ee596a0a12a7b"
#   instance_type     = "t3.micro"
#   subnet_id         = aws_subnet.private_subnet_1.id
#   availability_zone = "ap-southeast-2a"
#   security_groups   = [aws_security_group.web_sg.id]

#   user_data = <<-EOF
#                   #!/bin/bash
#                   sudo yum update -y
#                   sudo amazon-linux-extras install nginx1 -y
#                   sudo systemctl start nginx
#                   sudo systemctl enable nginx
#                   EOF

#   tags = {
#     Name = "Web-Server-1"
#   }
# }
# resource "aws_instance" "web_server2" {
#   ami               = "ami-0035ee596a0a12a7b"
#   instance_type     = "t3.micro"
#   subnet_id         = aws_subnet.private_subnet_2.id
#   availability_zone = "ap-southeast-2a"
#   security_groups   = [aws_security_group.web_sg.id]

#   user_data = <<-EOF
#                   #!/bin/bash
#                   sudo yum update -y
#                   sudo amazon-linux-extras install nginx1 -y
#                   sudo systemctl start nginx
#                   sudo systemctl enable nginx
#                   EOF

#   tags = {
#     Name = "Web-Server-2"
#   }
# }
