resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.template", {
    master_nodes = aws_instance.master_nodes.*.public_ip
    worker_nodes = aws_instance.workers_nodes.*.public_ip
  })
  filename = "${path.module}/../ansible/hosts.ini"
}