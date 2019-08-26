# Create a new ssh key 
resource "ibm_compute_ssh_key" "ssh_key" {
  label      = "${var.ssh-label}-${random_id.val.hex}"
  notes      = "for VM"
  public_key = "${var.ssh-key}"
}

resource "ibm_compute_vm_instance" "vm_local_exec_sample" {
    hostname = "${var.vm-hostname}"
    domain = "${var.vm-domain}"
    os_reference_code = "${var.vm-os-reference-code}"
    datacenter = "${var.datacenter}"
    network_speed = 10
    hourly_billing = true
    private_network_only = false
    cores = 1
    memory = "${var.vm-memory}"
    disks = [25, 10, 20]
    user_metadata = "{\"value\":\"newvalue\"}"
    dedicated_acct_host_only = true
    local_disk = false
    ssh_key_ids = ["${ibm_compute_ssh_key.ssh_key.id}"]

    /*
    provisioner "file" {
      source = "nginx.sh"
      destination = "/tmp/nginx.sh"
    }
    */

    provisioner "remote-exec" {
      connection {
      type     = "ssh"
      user     = "root"
      private_key = "${var.private_key}"
    }
      inline = [
        #"sh /tmp/nginx.sh"
        "yum upgrade -y",
        "yum install epel-release -y",
        "yum install nginx -y",
        "systemctl start nginx"
      ]
    }
}

resource "random_id" "val" {
  byte_length = "2"
}
