variable "aws_region" {
  default = "us-west-2"
}

variable "key_name" {
  default = "Automationkey"
}
variable "vpc_cidr" {
  default = "172.0.0.0/24"
}
variable "subnets_cidr" {
  type    = list(string)
  default = ["172.0.0.0/25", "172.0.0.128/25"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b"]
}
variable "kubernetes_ami" {
  default = "ami-00a38949ddb2ddb5c"
}
variable "master_instance_type" {
  default = "t2.medium"
}
variable "worker_instance_type" {
  default = "t2.micro"
}
variable "private_key_path" {
  default = "Automationkey.pem"
}
variable "jenkins_ami" {
  default = "ami-01e78c5619c5e68b4"
}
variable "jenkins_instance_type" {
  default = "t2.micro"
}
variable "sonarQube_ami" {
  default = "ami-01e78c5619c5e68b4"
}
variable "sonarQube_instance_type" {
  default = "t2.medium"
}
variable "nexus_ami" {
  default = "ami-01e78c5619c5e68b4"
}
variable "nexus_instance_type" {
  default = "t2.medium"
}
variable "tomcat_ami" {
  default = "ami-01e78c5619c5e68b4"
}
variable "tomcat_instance_type" {
  default = "t2.micro"
}

variable "prometheus_ami" {
  default = "ami-01e78c5619c5e68b4"
}
variable "prometheus_instance_type" {
  default = "t2.micro"
}
