provider "aws" {
  region = "ca-central-1"
}

# Use existing VPC and Subnet IDs where Jenkins is running

resource "aws_security_group" "sg_terraform" {
    vpc_id = "vpc-077075c8b4c08e59d"  # Existing VPC ID
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (can be restricted)
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP
    }
    ingress {
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]  # Allow all outgoing traffic
    }
    
    tags = {
      Name = "sg_terraform"
    }
}

resource "aws_instance" "app_server" {
    ami             = "ami-0eb9fdcf0d07bd5ef"  # Example AMI, adjust as needed
    instance_type   = "t2.micro"
    subnet_id       = "subnet-01c6f07c2dc404623"  # Existing Subnet ID
    security_groups = [aws_security_group.sg_terraform.id]
    
<<<<<<< HEAD
    user_data = file("install.sh")  # Reference the install.sh script to install your software

=======
    user_data = file("install.sh")
>>>>>>> ca5f3b6410682e91dbd585a0f54e0373f2ee4e67
    tags = {
      Name = "AppServer"
    }
<<<<<<< HEAD
=======
  
>>>>>>> ca5f3b6410682e91dbd585a0f54e0373f2ee4e67
}
