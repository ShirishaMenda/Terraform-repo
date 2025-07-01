#create tagretgroup1
resource "aws_lb_target_group" "tg1" {
  name     = "singapore-tg1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.name.id
  health_check {
    path     = "/index.html"
    protocol = "HTTP"
    # matcher             = "200-399"
    # interval            = 30
    # timeout             = 5
    # healthy_threshold   = 2
    # unhealthy_threshold = 2
  }

  tags = {
    Name = "singapore-tg1"
  }
}

resource "aws_lb_target_group_attachment" "private_instance1" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.frontendec2.id
  port             = 80
}

#create tagretgroup2
resource "aws_lb_target_group" "tg2" {
  name     = "singapore-tg2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.name.id
  health_check {
    path     = "/index.html"
    protocol = "HTTP"
    # matcher             = "200-399"
    # interval            = 30
    # timeout             = 5
    # healthy_threshold   = 2
    # unhealthy_threshold = 2
  }

  tags = {
    Name = "singapore-tg2"
  }
}

resource "aws_lb_target_group_attachment" "private_instance2" {
  target_group_arn = aws_lb_target_group.tg2.arn
  target_id        = aws_instance.backendec2.id
  port             = 80
}
