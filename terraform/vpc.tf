resource "aws_vpc" "kubeadm_ansible_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "kubeadm-ansible-vpc"
  }
}