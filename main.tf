variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_tag" "streaming" {
  name = "livestream"
}

resource "digitalocean_droplet" "streaming" {
  name               = "livestream"
  image              = "ubuntu-18-04-x64"
  size               = "512mb"
  region             = "nyc3"
  ipv6               = true
  private_networking = false
  tags               = [digitalocean_tag.streaming.name]
  ssh_keys           = ["35:85:0a:29:a5:51:c3:ef:9b:23:29:dd:1e:36:7a:01"]

  # size               = "s-2vcpu-4gb"

  provisioner "local-exec" {
    command = "sleep 20; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i ${digitalocean_droplet.streaming.ipv4_address}, streaming.yml"
  }

}

output "stream_to" {
  value = digitalocean_droplet.streaming.ipv4_address
}
