provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-mleger"
    key    = "clojure_wang"
    region = "us-west-2"
  }
}

resource "aws_key_pair" "mleger" {
  key_name   = "mleger-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "clojure_wang" {
  name        = "clojure_wang"
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

resource "aws_instance" "clojure_wang" {
  ami                    = "ami-1ee65166"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.mleger.id}"
  vpc_security_group_ids = ["${aws_security_group.clojure_wang.id}"]

  provisioner "file" {
    source      = "jeff_key.pub"
    destination = "/tmp/jeff_key.pub"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
    }
  }

  provisioner "file" {
    source      = "jeff.exercism"
    destination = "/tmp/jeff.exercism"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
    }
  }

  provisioner "remote-exec" {
    script = "bootstrap.sh"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
    }
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.clojure_wang.id}"
}

output "ssh" {
  value = "ssh ubuntu@${aws_eip.ip.public_ip}"
}
