provider "aws" {
  region = "us-east-1"  // Change to your preferred region
}
# Upload your SSH public key (devops-task.pub) to AWS
resource "aws_key_pair" "jenkins_key" {
  key_name   = "devops-task-key"                          # AWS name for your key pair
  public_key = file("~/.ssh/devops-task.pub")             # Path to your SSH public key file
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0b09ffb6d8b58ca91"  // Use a current Amazon Linux 2 AMI ID (find via AWS Console)
  instance_type = "t3.small"
  key_name      = aws_key_pair.jenkins_key.key_name  // Your SSH key pair
  subnet_id                   = "subnet-00bd14ba947b688ab"   # Your subnet here
  associate_public_ip_address = true
  vpc_security_group_ids = ["sg-047200ce8fe0d8e0f"]  // Your security group (allow ports 22, 8080)
  
  tags = {
    Name = "Jenkins-EC2"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install java-11-openjdk-devel -y
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sed -i 's/gpgcheck=1/gpgcheck=0/' /etc/yum.repos.d/jenkins.repo
              yum install jenkins -y
              systemctl enable jenkins
              systemctl start jenkins
              EOF 
}

output "instance_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
