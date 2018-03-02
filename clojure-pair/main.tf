provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-mleger"
    key    = "clojure-pair"
    region = "us-west-2"
  }
}

module "resources" {
  source      = "../resources"
  environment = "clojure-pair"

  workstation-scripts = [
    "../scripts/personal-station.sh",
    "../scripts/clojure.sh",
    "../scripts/exercism.sh",
    "../scripts/jeff-pairing-station.sh",
  ]
}

resource "null_resource" "pairing-keys" {
  triggers {
    aws_instance = "${module.resources.public_ip}"
  }

  provisioner "file" {
    source      = "key.exercism"
    destination = "/tmp/key.exercism"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
      host    = "${module.resources.public_ip}"
    }
  }

  provisioner "file" {
    source      = "jeff_key.pub"
    destination = "/tmp/jeff_key.pub"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
      host    = "${module.resources.public_ip}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "~/bin/exercism configure --key $(cat /tmp/key.exercism)",
      "cat /tmp/jeff_key.pub >> ~/.ssh/authorized_keys",
    ]

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
      host    = "${module.resources.public_ip}"
    }
  }
}

output "public_ip" {
  value = "${module.resources.public_ip}"
}
