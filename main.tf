resource "aws_vpc" "Terraform-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "Terraform-vpc"
    }
  
}

resource "aws_subnet" "Terraform-subnets" {
    vpc_id = aws_vpc.Terraform-vpc.id
    cidr_block = "10.0.0.0/24"

    tags = {
      Name = "Terrafrom-subnets"
    }
  
}

resource "aws_internet_gateway" "Terraform-internet_gateway" {
    vpc_id = aws_vpc.Terraform-vpc.id

    tags = {
      Name = "Terrafrom-internetgateway"
    }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.Terraform-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Terraform-internet_gateway.id

    }
    tags = {
      Name = "route_table"
    }
}
resource "aws_route_table_association" "Terraform-route_table_association" {
    subnet_id = aws_subnet.Terraform-subnets.id
    route_table_id = aws_route_table.public_rt.id
  
}
resource "aws_security_group" "sg_terraform" {
    vpc_id = aws_vpc.Terraform-vpc.id
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
      Name = "sg_terraform"
    }
}


resource "aws_instance" "app_server" {
    ami = "ami-0208b77a23d891325"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.Terraform-subnets.id
    security_groups = [aws_security_group.sg_terraform.id]
    tags = {
      Name= "AppServer"
    }
  
}