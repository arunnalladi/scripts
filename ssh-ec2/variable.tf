variable "ami-id" {
  description = "This variable is used to define ami id"
  default     = "ami-074dc0a6f6c764218"
}

variable "aws-region" {
  default = "ap-south-1"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}
