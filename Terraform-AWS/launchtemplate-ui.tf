resource "aws_launch_template" "sigma-ui-template" {
  name_prefix   = "sigma-ui-template"
  image_id      = "ami-0dc633995664f082b"
  instance_type = "t3a.nano"
  user_data = filebase64("userdata-ui.sh")
}
resource "aws_autoscaling_group" "sigma-ui-asg" {
  availability_zones        = ["ap-south-1a"]
  name                      = "sigma-ui-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 180
  health_check_type         = "ELB"
  force_delete              = true
  termination_policies      = ["OldestInstance"]
  launch_template {
    id      = aws_launch_template.sigma-ui-template.id
    version = "$Latest"
  }
  target_group_arns = [ aws_lb_target_group.sigma-ui-tg.arn ]
}
resource "aws_autoscaling_policy" "test" {
  name                   = "test"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.sigma-ui-asg.name
  scaling_adjustment     = 2
  cooldown               = 180
}
#data "aws_vpc" "main"{
#    id="vpc-0fa1dcbf4951c2e69"
#}

data "aws_subnet_ids" "test" {
  vpc_id = aws_vpc.sigma-vpc.id
}

data "aws_subnet" "test" {
  for_each = aws_subnet_ids.test.ids
  id       = each.value
}
resource "aws_lb" "sigma-ui-lb" {
  name               = "sigma-ui-lb"
  internal           = false
  load_balancer_type = "network"
   subnets            = [for subnet in data.aws_subnet.test : subnet.id]
  #subnets = [aws_subnet.sigma-vpc-pb-1a.id,aws_subnet.sigma-vpc-pb-1b.id]

}
resource "aws_lb_listener" "sigma-ui-lb" {
  load_balancer_arn = aws_lb.sigma-ui-lb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sigma-ui-tg.arn
  }
}
resource "aws_lb_target_group" "sigma-ui-tg" {
  name     = "test"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}