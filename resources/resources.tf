provider "aws" {
  region = "us-west-2"
}

variable "environment" {
  type = "string"
}

variable "workstation-scripts" {
  type    = "list"
  default = []
}

resource "aws_key_pair" "key-pair" {
  key_name   = "${var.environment}-key"
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

  # allow connections on 8888 to support jupyter notebook
  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow connections on 8080 to support web app development
  ingress {
    from_port   = 8080
    to_port     = 8080
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
  key_name               = "${aws_key_pair.key-pair.id}"
  vpc_security_group_ids = ["${aws_security_group.security-group.id}"]

  tags {
    Name = "${var.environment}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/init.sh"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
    }
  }

  provisioner "remote-exec" {
    scripts = "${var.workstation-scripts}"

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
