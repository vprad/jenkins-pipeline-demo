provider "aws" {
  region = var.region
}
#1
resource "aws_instance" "ex" {
  ami           = "ami-05548f9cecf47b442"
  instance_type = "t2.micro"
  tags = {
    Name = "jenkins-pipeline-demo"
    Environment = "Production"
  }
}
