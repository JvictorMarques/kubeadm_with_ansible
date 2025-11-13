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
