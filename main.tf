provider "aws" {
  region = var.region  # Change to your desired AWS region
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = ["subnet-09e5086cb5732ef92", "subnet-0c560d4762e677007", "subnet-012bf135fc92de1b3", "subnet-09ed9c8d387893fe4", "subnet-07be01196f968b01d"]
  }
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key = "my-ssh-key"
  }

  launch_template {
    name   = "my-node-group-launch-template"  # Update with the actual launch template name
    version = "$Latest"  # Update with the desired version
  }

  node_role_arn = aws_iam_role.eks_cluster.arn
  subnet_ids    = ["subnet-09e5086cb5732ef92", "subnet-0c560d4762e677007", "subnet-012bf135fc92de1b3", "subnet-09ed9c8d387893fe4", "subnet-07be01196f968b01d"]  // Choose the appropriate subnets

  instance_types = ["t2.medium"]

  tags = {
    Terraform = "true"
  }
}



resource "aws_security_group" "my_security_group" {
  name_prefix = "my-security-group-"
  
  vpc_id = aws_eks_cluster.my_cluster.vpc_config[0].vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080  // Change to your desired custom TCP port
    to_port     = 8080  // Change to your desired custom TCP port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Add more ingress and egress rules if needed
}


