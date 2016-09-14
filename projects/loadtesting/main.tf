provider "openstack" {
  user_name   = "gTmzDt2bYd9x"
  tenant_name = "7660444795968807"
  password    = "vzPkfE4gSU7tDUxcz7AtfqfqsXZ5yCbu"
  auth_url    = "https://auth.cloud.ovh.net/v2.0"
}

output "instance" {
  value = "${openstack_compute_instance_v2.test.access_ip_v4}"
}
