variable "ec2_instance_name" {
  type        = string
  description = "this variable hold ec2 instance name"
  default     = "terra-auto-server"

}

variable "ec2_volume_size" {
  type        = number
  description = "this variable hold deafult volume size"
  default     = 8

}

variable "aws_ec2_instance_state" {
  type        = string
  description = "this variable hold deafult volume size"
  default     = "running"

}

variable "env" {
  type        = string
  description = "this variable hold deafult environments"
  # default     = "dev" # assigned during runtime

}

variable "instance_type" {
  type        = string
  description = "this variable hold deafult instance_type"
  default     = "t3.micro"
}

variable "ec2_count" {
  type        = number
  description = "this variable hold deafult count"
  # default     = 1 this will assign during local variable from root folder
}
