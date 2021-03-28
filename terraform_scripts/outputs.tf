output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Kubernetes_Servers.public_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.Kubernetes_Workers.public_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.jenkins_worker.public_ip
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.SonarQube_worker.public_ip
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.nexus_worker.public_ip
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.tomcat_worker.public_ip
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.prometheus_worker.public_ip
}
