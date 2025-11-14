resource "aws_vpc" "kubeadm_ansible_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "kubeadm-ansible-vpc"
  }
}

resource "aws_subnet" "kubeadm_ansible_subnet" {
  vpc_id                  = aws_vpc.kubeadm_ansible_vpc.id
  cidr_block              = var.kubeadm_ansible_subnet.cidr_block
  availability_zone       = var.kubeadm_ansible_subnet.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "kubeadm-ansible-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.kubeadm_ansible_vpc.id

  tags = {
    Name = "kubeadm-ansible-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.kubeadm_ansible_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "kubeadm-ansible-public-rt"
  }
}

resource "aws_route_table_association" "public_association" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.kubeadm_ansible_subnet.id
}