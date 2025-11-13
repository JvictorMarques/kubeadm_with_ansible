variable "node_instance" {
  type = object({
    ami           = string
    instance_type = string
  })
  description = "Description of the master node instance"
  default = {
    ami           = "ami-0ecb62995f68bb549"
    instance_type = "t2.micro"
  }
}

variable "workers_count" {
  type        = number
  description = "Number of worker nodes"
  default     = 2
}

variable "kubeadm_ansible_vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "kubeadm_ansible_subnet" {
  type = object({
    cidr_block        = string
    availability_zone = string
  })
  description = "Subnet configuration including CIDR block and availability zone"
  default = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  }
}