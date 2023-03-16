provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

## AWS instance creation.
#
#resource "aws_key_pair" "aws_key_pair" {
#  key_name	= "kriston-quest-tf"
#  public_key	= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCFC9ldp6UD5CDO6qIK/rSdube9X+VXtmxr23HQDo9rNBnwEnMWt8I1XxILpCuq4R1HTmpEVOFmiJqof+swvEHRoDqoqaSd7pt/BAYIMQOQiGUqsVsG3o235dQWPnPoi2L9mSbGRB/eJDgyFYiQ1BuG/XgQuYoEELfS4Q2L+tSS8GoVRdmjHpI3GpboELSvhqlDMbQjxLY3zrHO5Etevxjohtvfd25gTEebemBXw8/RN+tXnQNtpTQOY4x/MK5vl48rMhO1Kcb89XrRR5SGwMVi1d0pwo8ljmNDp7M97us3zyx7Loc1s7iXzonGki1cJY66WyPBahM5nxNwGOjGVbiH"
#}
#
#
#resource "aws_instance" "quest" {
#  ami           = "ami-005f9685cb30f234b"
#  instance_type = "t2.micro"
#  subnet_id	= "subnet-0b2fc95ec093421be"
#  key_name	= "kriston-quest-tf"
#
#  tags = {
#    Name = "quest server"
#  }    
#}


## AWS ECR Docker repository creation.
resource "aws_ecr_repository" "kriston-quest" {

  name 			= "kriston-quest"
  image_tag_mutability	= "IMMUTABLE"

}


## AWS ECS Docker cluster creation.

resource "aws_ecs_cluster" "kriston-quest" {
  name			= "kriston-quest"
}

resource "aws_ecs_service" "kriston-quest" {
  name			= "kriston-quest"
  cluster		= aws_ecs_cluster.kriston-quest.id
  task_definition	= aws_ecs_task_definition.kriston-quest-task-definition.arn
  launch_type		= "FARGATE"
  network_configuration {
    subnets		= ["subnet-0b2fc95ec093421be"]
    assign_public_ip	= true
  }
  desired_count		= 1
}

resource "aws_ecs_task_definition" "kriston-quest-task-definition" {
  family		= "kriston-quest-task-definition"
  network_mode		= "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory		= "1024"
  cpu			= "512"
  execution_role_arn	= "arn:aws:iam::972271442698:role/ecsTaskExecutionRole"
  container_definitions	= <<EOF
[
 {
    "name": "demo-container",
    "image": "972271442698.dkr.ecr.us-east-1.amazonaws.com/kriston-quest:latest",
    "memory": 1024,
    "cpu": 512,
    "essential": true,
    "entryPoint": ["/"],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOF
}
