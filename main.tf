# Configure the OpenStack Provider
provider "openstack" {
    user_name  = "admin"
    tenant_name = "admin"
    domain_id = "default"
    password  = "password"
    auth_url  = "http://192.168.3.247:5000/v3"
}

#resource "openstack_compute_floatingip_v2" "fip" {
#  pool  = "public"
#}

resource "openstack_networking_floatingip_v2" "fip1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "salt_extip" {
  floating_ip = "${openstack_networking_floatingip_v2.fip1.address}"
  instance_id = "${openstack_compute_instance_v2.salt.id}"
}

#resource "openstack_compute_floatingip_v2" "powerdns_extip" {
#  pool = "public"
#}
#
#resource "openstack_compute_floatingip_v2" "salt_extip" {
#  pool = "public"
#}
#
#resource "openstack_compute_floatingip_v2" "extip" {
#  pool = "public"
#}
#
#resource "openstack_compute_keypair_v2" "mykeypair" {
#  name = "mykeypair"
#  public_key = "${var.public_key}"
#}
#
#resource "openstack_compute_instance_v2" "powerdns" {
#  name = "powerdns"
#  image_id = "a071ca3e-4640-45b6-b76e-fd8cf0d56c46"
#  flavor_id = "2"
#  key_pair = "${var.aws_key_name}"
#  security_groups = ["default"]
#  region = "RegionOne"
#
#  network {
#    name = "private"
#    floating_ip = "${openstack_compute_floatingip_v2.powerdns_extip.address}"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sudo yum update -y"
#    ]
#    connection {
#      user = "centos"
#      private_key = "${file("../../key/mykeypair.pem")}"
#      host = "${openstack_compute_floatingip_v2.powerdns_extip.address}"
#    }
#  } 
#}
#
resource "openstack_compute_instance_v2" "salt" {
  name = "salt"
  image_id = "44af7074-ce63-46c9-972b-4148fb6ed38e"
  flavor_id = "3"
  key_pair = "alpha"
  security_groups = ["default"]
  region = "RegionOne"

  network {
    name = "private"
#    floating_ip = "${openstack_compute_floatingip_v2.salt_extip.address}"
  }
}
