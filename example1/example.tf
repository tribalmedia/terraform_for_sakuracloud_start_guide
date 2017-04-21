provider "aws" {
 access_key = "PUT_YOUR_ACCESS_KEY"
 secret_key = "PUT_YOUR_SECRET_KEY"
 region = "ap-northeast-1"
}

resource "aws_instance" "example" {
 ami = "ami-0c11b26d"
# ami = "ami-be4a24d9"
 instance_type = "t2.micro"
}
