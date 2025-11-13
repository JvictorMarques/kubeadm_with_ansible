resource "aws_instance" "master_nodes" {
  subnet_id                   = aws_subnet.kubeadm_ansible_subnet.id
  ami                         = var.node_instance.ami
  instance_type               = var.node_instance.instance_type
  associate_public_ip_address = true

  tags = {
    Name = "master-nodes"
  }
}

resource "aws_instance" "workers_nodes" {
  subnet_id     = aws_subnet.kubeadm_ansible_subnet.id
  ami           = var.node_instance.ami
  instance_type = var.node_instance.instance_type
  count         = var.workers_count

  tags = {
    Name = "worker-nodes-${count.index + 1}"
  }
}