terraform {
  backend "s3" {
    bucket         = "myuniqueterraform-series-s3-backend"
    key            = "terraform-jenkins"
    region         = "us-west-2"
    encrypt        = true
    role_arn       = "arn:aws:iam::188289434504:role/Myuniqueterraform-SeriesS3BackendRole"
    dynamodb_table = "myuniqueterraform-series-s3-backend"
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Server"
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}
