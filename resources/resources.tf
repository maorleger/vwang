provider "aws" {
  region = "us-west-2"
}

variable "environment" {
  type = "string"
}

variable "script-path" {
  type = "string"
}

resource "aws_key_pair" "mleger" {
  key_name   = "mleger-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "security-group" {
  name        = "${var.environment}"
  description = "Allow ssh connections on port 22 and open up egrees"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "workstation-ec2" {
  ami                    = "ami-1ee65166"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.mleger.id}"
  vpc_security_group_ids = ["${aws_security_group.security-group.id}"]

  provisioner "remote-exec" {
    script = "${var.script-path}"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
    }
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.workstation-ec2.id}"
}

output "public_ip" {
  value = "${aws_eip.ip.public_ip}"
}
