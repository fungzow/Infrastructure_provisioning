#1. Create and initialise a backend for state file storage.
terraform {
   backend "s3" {
     bucket         = "landmark-automation-kenmak"
     key            = "global/s3/terraform.tfstate"
     region         = "us-west-2"
     dynamodb_table = "terraform_state"
   }
 }

#2. Create an s3 bucket
resource "aws_s3_bucket" "terraform_state"{
     bucket = "landmark-automation-kenmak"

     lifecycle {
        prevent_destroy = true
       }
     versioning {
        enabled = true
       }
   } 

#3. Create a dynamodb to lock the state file.
resource "aws_dynamodb_table" "terraform-lock" {
    name           = "terraform_state"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }
 } 

#4. Generate ssh_key
   resource "tls_private_key" "ansible" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#5. Get ssh_key
resource "aws_key_pair" "ansiblesshkey" {
  public_key = tls_private_key.ansible.public_key_openssh
}
#6. Create a kubernetes master instance.
resource "aws_instance" "Kubernetes_Servers" {
  count                  = 1
  ami                    = var.kubernetes_ami
  instance_type          = var.master_instance_type
  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  subnet_id              = element(aws_subnet.kubernetes_subnets.*.id, count.index)
  key_name               = var.key_name
  user_data        = file("create_ansible_user.sh")
    tags = {
        Name = "Kubernetes_Servers"
        Type = "Kubernetes_Master"
   }

#7. Read and Copy the ssh_key generated to remote server.
  provisioner "file" {
    content     = aws_key_pair.ansiblesshkey.public_key
    destination = "/tmp/private_key"
  }
#8. Execute commands in the remote server.
  provisioner "remote-exec" {
      inline = [
         "sudo mkdir -p /home/ansible/.ssh/authorized_keys/",
         "sudo cp /tmp/private_key /home/ansible/.ssh/authorized_keys/",
         ]
     }
#9. This is what the local machine uses to connect to the remote machine.
connection {
   type            = "ssh"
    user            = "ec2-user"
    private_key     = file(var.private_key_path)
    host            = self.public_ip

  }
}

#10. Create kubernetes worker nodes.
resource "aws_instance" "Kubernetes_Workers" {
  count                  = 2
  ami                    = var.kubernetes_ami
  instance_type          = var.worker_instance_type
  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  subnet_id              = element(aws_subnet.kubernetes_subnets.*.id, count.index)
  key_name               = var.key_name
  user_data              = file("create_ansible_user.sh")
  tags ={
    Name = "Kubernetes_Servers"
    Type = "Kubernetes_Worker"
   }

#11. Reads and Copies the ssh_keys to the remote kubernetes worker nodes.
  provisioner "file" {
    content     = aws_key_pair.ansiblesshkey.public_key
    destination = "/tmp/private_key"
  }
#12. Executes commands in the remote kubernetes worker nodes.
  provisioner "remote-exec" {
      inline = [
         "sudo mkdir -p /home/ansible/.ssh/authorized_keys/",
         "sudo cp /tmp/private_key /home/ansible/.ssh/authorized_keys/",
          ]
  }
#13. This is how the local machine connects to the kubernetes worker nodes.
 connection {
    user            = "ec2-user"
    private_key     = file(var.private_key_path)
    host            = self.public_ip
   }
}

#14. Create Jenkins worker nodes.
resource "aws_instance" "jenkins_worker" {
  count                  = 1
  ami                    = var.jenkins_ami
  instance_type          = var.jenkins_instance_type
  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  subnet_id              = element(aws_subnet.kubernetes_subnets.*.id, count.index)
  key_name               = var.key_name
      tags ={
        Name = "jenkins_server"
        Type = "jenkins_worker"
     }
 }
#15. Create a sonarQube server
resource "aws_instance" "sonarQube_worker" {
  count                  = 1
  ami                    = var.sonarQube_ami
  instance_type          = var.sonarQube_instance_type
  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  subnet_id              = element(aws_subnet.kubernetes_subnets.*.id, count.index)
  key_name               = var.key_name

  tags ={
    Name = "SonarQube_server"
    Type = "sonarQube_worker"
   }
}
#16. Create Nexus server.
resource "aws_instance" "nexus_worker" {
  count                  = 1
  ami                    = var.nexus_ami
  instance_type          = var.nexus_instance_type
 vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  subnet_id              = element(aws_subnet.kubernetes_subnets.*.id, count.index)
  key_name               = var.key_name

  tags ={
    Name = "Nexus_server"
    Type = "nexus_worker"
   }
}
#17. Create a Tomcat server .
resource "aws_instance" "tomcat_worker" {
  count                  = 1
  ami                    = var.tomcat_ami
  instance_type          = var.tomcat_instance_type
  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  subnet_id              = element(aws_subnet.kubernetes_subnets.*.id, count.index)
  key_name               = var.key_name

  tags ={
    Name = "Tomcat_server"
    Type = "tomcat_worker"
   }
 }

#18. Create a Prometheus server .
resource "aws_instance" "prometheus_worker" {
  count                  = 1
  ami                    = var.prometheus_ami
  instance_type          = var.prometheus_instance_type
  vpc_security_group_ids = [aws_security_group.kubernetes_sg.id]
  subnet_id              = element(aws_subnet.kubernetes_subnets.*.id, count.index)
  key_name               = var.key_name

  tags ={
    Name = "Prometheus_server"
    Type = "prometheus_worker"
   }
 }
