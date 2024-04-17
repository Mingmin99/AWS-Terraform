resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id
}

resource "aws_lb" "alb" {
  name               = "tf-lab-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] # 퍼블릭 서브넷 ID

  security_groups = [aws_security_group.alb_sg.id] # 적절한 보안 그룹 ID

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg" {
  name     = "tf-lab-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    matcher             = "200"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
