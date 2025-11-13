resource "aws_instance" "master_nodes" {
  vpc_id                      = aws_vpc.kubeadm_ansible_vpc.id
  ami                         = var.node_instance.ami
  instance_type               = var.node_instance.instance_type
  associate_public_ip_address = true

  tags = {
    Name = "master-nodes"
  }
}

resource "aws_instance" "workers_nodes" {
  vpc_id        = aws_vpc.kubeadm_ansible_vpc.id
  ami           = var.node_instance.ami
  instance_type = var.node_instance.instance_type
  count         = var.workers_count

  tags = {
    Name = "worker-nodes-${count.index + 1}"
  }
}