provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-mleger"
    key    = "allcentury-pair"
    region = "us-west-2"
  }
}

module "resources" {
  source      = "../resources"
  environment = "allcentury-pair"

  workstation-scripts = [
    "../scripts/personal-station.sh",
    "../scripts/docker.sh",
    "../scripts/anthony-pairing-station.sh",
  ]
}

resource "null_resource" "pairing-keys" {
  triggers {
    aws_instance = "${module.resources.public_ip}"
  }

  provisioner "file" {
    source      = "anthony_key.pub"
    destination = "/tmp/anthony_key.pub"

    connection {
      type    = "ssh"
      user    = "ubuntu"
      timeout = "1m"
      host    = "${module.resources.public_ip}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cat /tmp/anthony_key.pub >> ~/.ssh/authorized_keys",
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
