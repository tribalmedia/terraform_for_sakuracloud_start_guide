provider "aws" {
 access_key = "${var.access_key}"
 secret_key = "${var.secret_key}"
 region = "${var.region}"
}

resource "aws_instance" "example" {
# ami = "ami-0c11b26d"
# ami = "ami-be4a24d9"
  ami = "${var.amis[var.region]}"
 instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
    instance = "${aws_instance.example.id}"
}

output "ip" {
    value = "${aws_eip.ip.public_ip}"
}

variable "cidrs" { default = ["10.0.0.0/16", "10.1.0.0/16"] }
output "c" {
    value = "${element(var.cidrs,0)}"
}
