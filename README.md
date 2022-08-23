# Deploying a go web service (greeter) in a highly available environment using ECS

This infrastructure in AWS is created using Terraform. 
It consists of:
- Virtual Private Cloud (VPC)
- Public subnets in 3 availability zones
- Elastic Container Service (ECS)
- Application Load Balancer (ALB)
- Auto Scaling Group(ASG)
- Amazon Elastic Container Registry (ECR)

# #Steps to create the infrastructure on AWS

# #Prerequisites:
1. AWS Account
2. AWS CLI and Terraform CLI installed
3. Clone the repo `git clone https://github.com/NandiniSankhyan/ecs_infra.git`

# #Steps to create ECR

1. cd ecs_infra/terraform-ecs/ecr
2. terraform init
3. terraform plan
4. terraform apply

- After creating the ECR push the docker image by using the push commands.
- Then update the Image URI in container-definitions/definition.json file.

# #Steps to create ECS Cluster

1. cd ecs_infra/terraform-ecs
2. terraform init
3. terraform plan
4. terraform apply

# # #Variables to pass:
1. cluster_name: Name of the desired ECS Cluster.
1. ssh_key_name: Name of .pem ssh key for aws_launch_configuration.

## Description

Cluster is created using container instances: EC2 launch type. 

`ecs.tf`:
  - Resource: 'aws_ecs_cluster':
    Cluster of container instances _cluster-greeter_
  - Resource: 'aws_ecs_capacity_provider'
    Capacity provider is basically AWS Autoscaling group for EC2 instances. Managed scaling is enabled, that is Amazon ECS manages the scale-in and scale-out of the Auto Scaling group when creating the capacity provider. Here Target capacity is set to 85% that means the Amazon EC2 instances in the Auto Scaling group will be utilized for 85% and after that any instances not running any tasks will be scaled in.
  - Resource: 'aws_ecs_task_definition'
    Task definition with family _greeter-family_, volume and container definition is defined in the file container-definitions/definition.json
  - Resource: 'aws_ecs_service'
    Service _greeter-service_, desired count is set to 10, which means there are 10 tasks will be running simultaneously on your cluster. Here the service scheduler strategie REPLICA is used. Application load balancer is attached to this service, so the traffic can be distributed between those tasks.
  - Resource: 'aws_cloudwatch_log_group'
    Log Group /ecs/greeter-container will have all the logs from ECS Service

`vpc.tf`:
  - Verified module `vpc` is imported and used from Terraform Registry.

`asg.tf`:
  - Resources created:
    1. launch configuration
    2. security groups for EC2 instances
    3. auto-scaling group

`iam.tf`:
  - Created roles that will help us to associate EC2 instances to clusters and other tasks.

`alb.tf`:
  - Created Application Load Balancer with target groups, security group and listener. 

# #Deleting the infrastructure?
1. Run `terraform destroy`

# #Steps to Launch the webApp 
- Copy the alb dns in the output in the browser and the main page of greeter app will display.
- To to path based routing you can type dns/param?name=anyname 