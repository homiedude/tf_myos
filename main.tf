# Configure the OpenStack Provider
provider "openstack" {
    user_name  = "hernan"
    tenant_name = "services"
    password  = "ArcAnge1"
    auth_url  = "http://192.168.3.125:5000/v2.0"
}

resource "openstack_compute_floatingip_v2" "powerdns_extip" {
  pool = "public"
}

resource "openstack_compute_floatingip_v2" "salt_extip" {
  pool = "public"
}

resource "openstack_compute_floatingip_v2" "extip" {
  pool = "public"
}

resource "openstack_compute_keypair_v2" "mykeypair" {
  name = "mykeypair"
  public_key = "${var.public_key}"
}

resource "openstack_compute_instance_v2" "powerdns" {
  name = "powerdns"
  image_id = "a071ca3e-4640-45b6-b76e-fd8cf0d56c46"
  flavor_id = "2"
  key_pair = "${var.aws_key_name}"
  security_groups = ["default"]
  region = "RegionOne"

  network {
    name = "private"
    floating_ip = "${openstack_compute_floatingip_v2.powerdns_extip.address}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y"
    ]
    connection {
      user = "centos"
      private_key = "${file("../../key/mykeypair.pem")}"
      host = "${openstack_compute_floatingip_v2.powerdns_extip.address}"
    }
  } 
}

resource "openstack_compute_instance_v2" "salt" {
  name = "salt"
  image_id = "a071ca3e-4640-45b6-b76e-fd8cf0d56c46"
  flavor_id = "2"
  key_pair = "${var.aws_key_name}"
  security_groups = ["default"]
  region = "RegionOne"

  network {
    name = "private"
    floating_ip = "${openstack_compute_floatingip_v2.salt_extip.address}"
  }
}
