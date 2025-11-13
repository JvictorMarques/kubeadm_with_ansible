resource "aws_vpc" "kubeadm_ansible_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "kubeadm-ansible-vpc"
  }
}

resource "aws_subnet" "kubeadm_ansible_subnet" {
  vpc_id            = aws_vpc.kubeadm_ansible_vpc.id
  cidr_block        = var.kubeadm_ansible_subnet.cidr_block
  availability_zone = var.kubeadm_ansible_subnet.availability_zone

  tags = {
    Name = "kubeadm-ansible-subnet"
  }
}