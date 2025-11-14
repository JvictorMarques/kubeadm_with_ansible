resource "aws_key_pair" "ansible_controller_key" {
  key_name   = "ansible-controller-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "master_nodes" {
  subnet_id              = aws_subnet.kubeadm_ansible_subnet.id
  ami                    = var.node_instance.ami
  instance_type          = var.node_instance.instance_type
  vpc_security_group_ids = [aws_security_group.nodes_sg.id]
  key_name               = aws_key_pair.ansible_controller_key.key_name

  tags = {
    Name = "master-nodes"
  }
}

resource "aws_instance" "workers_nodes" {
  subnet_id              = aws_subnet.kubeadm_ansible_subnet.id
  ami                    = var.node_instance.ami
  instance_type          = var.node_instance.instance_type
  vpc_security_group_ids = [aws_security_group.nodes_sg.id]
  key_name               = aws_key_pair.ansible_controller_key.key_name
  count                  = var.workers_count

  tags = {
    Name = "worker-nodes-${count.index + 1}"
  }
}

resource "aws_security_group" "nodes_sg" {
  name   = "nodes-security-group"
  vpc_id = aws_vpc.kubeadm_ansible_vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}