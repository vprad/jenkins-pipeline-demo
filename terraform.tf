provider "aws" {
  region = var.region
}

resource "aws_instance" "ex" {
  ami           = "ami-05548f9cecf47b442"
  instance_type = "t2.micro"
  tags = {
    Name = "Example EC2 Instance"
    Environment = "Production"
  }
}
