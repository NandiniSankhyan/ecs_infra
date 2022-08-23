resource "aws_ecs_cluster" "cluster-greeter" {
  name = var.cluster_name
  tags = {
    "ManagedBy" = "Terraform"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
  cluster_name = var.cluster_name

  capacity_providers = [aws_ecs_capacity_provider.capacity-greeter.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity-greeter.name
  }
}

resource "aws_ecs_capacity_provider" "capacity-greeter" {
  name = "capacity-provider-greeter"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

resource "aws_ecs_task_definition" "task-definition-greeter" {
  family                = "greeter-family"
  container_definitions = file("container-definitions/definition.json")
  network_mode          = "bridge"
  tags = {
    "ManagedBy" = "Terraform"
  }
}

resource "aws_ecs_service" "service" {
  name            = "greeter-service"
  cluster         = aws_ecs_cluster.cluster-greeter.id
  task_definition = aws_ecs_task_definition.task-definition-greeter.arn
  desired_count   = 10
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "terraform-aws-ecs-container-definition"
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.greeter-lb-listener]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/greeter-container"
  tags = {
    "ManagedBy" = "Terraform"
  }
}