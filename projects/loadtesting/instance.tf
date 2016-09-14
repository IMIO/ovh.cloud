resource "openstack_compute_instance_v2" "test" {
  # region provided by env variable
  name            = "test"
  region = "SBG1"
  image_id        = "7595a73f-31e3-42e0-ae75-8adf385d3060"        # Ubuntu 16.04 from `nova image-list`
  flavor_id       = "164fcc7e-7771-414f-a607-b388cb7b7aa0"        # vps-ssd-1 from `nova flavor-list`
  key_pair        = "${openstack_compute_keypair_v2.imio.name}"
  security_groups = ["${openstack_compute_secgroup_v2.ssh.name}"]

  metadata {
    key1 = "value1"
    key2 = "value2"
  }
}

resource "openstack_compute_keypair_v2" "imio" {
  # region provided by env variable
  name       = "imio"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFQ0dy/6b27W3M7r78vrU4YIb1/ZSByEVmqrPNVM8OEFRm+e8esh1yCq94itht8k8odtg7rZLqDTwuJujmiJBfHekfKTEQekN9qtdhYYurZrjRd4AMypBbjxCm9z1KLgdsaTgN6mPLyosqCUqqta/s4G8cKPreO24UjAOiaQvMyBwkqXisQAKiY7Z0F/iE2ssHsLypfk4nmlVLMIS8i01/Fzo+1Vv0AbjqjX07OdtEwz8vFv95wRPmvrl9UKhVvnJXKyC6TWyQgL79BagnOJUTsfaVtFjzOOsYiJkdNngoTkrzzfnBJ9JFkMdHdounch9Fcm9wjIEpAd46qEOyCcGh imio"
}

resource "openstack_compute_secgroup_v2" "ssh" {
  # region provided by env variable
  name        = "ssh"
  description = "ssh access"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}
