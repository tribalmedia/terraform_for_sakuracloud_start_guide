variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "ap-northeast-1"
}

variable "amis" {
  default = {
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    ap-northeast-1 = "ami-0c11b26d"
  }
}
