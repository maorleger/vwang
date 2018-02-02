provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "mleger" {
  key_name   = "mleger-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh connections on port 22"

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

resource "aws_instance" "clojure-club" {
  ami                    = "ami-1ee65166"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.mleger.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]

  provisioner "file" {
    source      = "~/.tmux.conf"
    destination = "~/.tmux.conf"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
    }
  }

  provisioner "file" {
    source      = "~/.vimrc_local"
    destination = "~/.vimrc_local"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
    }
  }

  provisioner "file" {
    source      = "~/.vimrc.bundles.local"
    destination = "~/.vimrc.bundles.local"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
    }
  }

  provisioner "file" {
    source      = "jeff_key.pub"
    destination = "/tmp/jeff_key.pub"

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
  instance = "${aws_instance.clojure-club.id}"
}

output "ip" {
  value = "ssh ubuntu@${aws_eip.ip.public_ip}"
}
