# Upload the public key to DigitalOcean
resource "digitalocean_ssh_key" "my_ssh_key" {
  name       = "Terraform Provisioned Key"
  public_key = file(var.ssh_public_key_path)
}

# Create the Droplet
resource "digitalocean_droplet" "web_server" {
  image    = "ubuntu-24-04-x64"      # Using the latest Ubuntu LTS
  name     = "tf-ansible-droplet"
  region   = "lon1"                  # London region; change as needed
  size     = "s-1vcpu-1gb"           # Standard $6/mo droplet
  ssh_keys = [digitalocean_ssh_key.my_ssh_key.fingerprint]

  # Optional: Add tags for easier management or filtering in Ansible
  tags = ["web", "terraform"]

  # 1. Wait for SSH to become available
  provisioner "remote-exec" {
    inline = ["echo 'SSH is up! Ready for Ansible.'"]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key_path)
      host        = self.ipv4_address
    }
  }

  # 2. Trigger Ansible locally
  provisioner "local-exec" {
    # We pass the IP directly using a comma to tell Ansible it's a host list, not a file.
    # We also disable host key checking so it doesn't pause to ask "Are you sure you want to connect?"
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.ssh_private_key_path} setup.yml"
  }
}
