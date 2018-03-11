provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-mleger"
    key    = "personal-station"
    region = "us-west-2"
  }
}

module "resources" {
  source      = "../resources"
  environment = "personal-station"

  workstation-scripts = [
    "../scripts/personal-station.sh",
    "../scripts/clojure.sh",
    "../scripts/exercism.sh",
    "../scripts/ruby.sh",
  ]
}

resource "null_resource" "exercism-key" {
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

  provisioner "remote-exec" {
    inline = [
      "~/bin/exercism configure --key $(cat /tmp/key.exercism)",
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
