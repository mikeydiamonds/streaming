# Streaming Server

This script allows you to stream live to Facebook, Youtube and Twitch at once without the bandwidth issues.

The code is designed to setup a restreaming server and will produce a custom RTMP streaming URL which is meant to be inserted into your local live streaming software like [Open Broadcaster](https://obsproject.com/) (OBS).

You'll no longer need an expensive paid account on restreaming platforms like [Restream.io](https://restream.io/) and can have total control over your broadcast.

The beauty of this streaming method is the server is ephemeral, meaning once the stream has ended you can `destroy` the server. This saves money and prevents malicious actors from tampering with your setup.

You will need to visit each platform to obtain your stream key and stream URL. Each time you live stream will require a new stream key.

### Facebook

Facebook's stream key and url are provided on the [Live page](https://www.facebook.com/live/producer) after selecting "Use Stream Key". The stream key is valid for 7 days according to Facebook.

### Youtube

Youtube's key and url are shown in the [classic live control room](https://www.youtube.com/live_dashboard).

### Twitch

Twitch supplies a permanent stream key at https://dashboard.twitch.tv/u/yourusername/settings/channel. The Twitch url can be obtained on their [Ingests](https://stream.twitch.tv/ingests/) page. Choose the location closest to your streaming server for best performance.

With these credentials gathered, update the variables in `/roles/streaming/defaults/main.yml`.

You can choose which platforms to stream on by setting `true` or `false` in the `stream_to_servicename` variable.

It's tested with [OBS](https://obsproject.com/) from macOS using the smallest Digital Ocean Droplet.

# Prerequisites

## Terraform

[Terraform](https://www.terraform.io/) is an orchestration tool used to let Digital Ocean we'd like a new server with certain specs at a certain data center. It's easy to install on macOS using [Homebrew](https://brew.sh/).

```
brew install terraform
```

## Ansible

[Ansible](https://www.ansible.com/) is a configuration management tool that installs all the software and configurations we need to make the streaming server operate. Again, we'll install Ansible with [Homebrew](https://brew.sh/)

```
brew install ansible
```

## Digital Ocean

You will need a [Digital Ocean](https://m.do.co/c/19eed3ad1d11) account.

Create a DO [personal access token](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/)

# Setup the Server

Clone this repository from your terminal and enter the new directory.

```
git clone git@github.com:mikeydiamonds/streaming.git && cd streaming
```

> The streaming credentials and DO token are sensitive data. Take care not to expose them.

Alter the stream keys, stream urls and select `true` or `false` on your desired platforms in `roles/streaming/defaults/main.yml`.

Add your Digital ocean API token to `terraform.tfvars`.

Now we can run the server script. Once this script is run you will incur costs from Digital Ocean.

> This script is set to use a \$5/mo DO droplet in NYC but feel free to make alterations in `main.tf`.

```
terraform plan && terraform apply --auto-approve
```

The Terraform orchestrator will automatically call the Ansible provisioning scripts.

When you're done with the server/live stream you can destroy the droplet and stop incurring costs.

```
terraform destroy -auto-approve
```

## The Live Stream

The script will output the url to add to OBS or similar streaming software after all the provisioning is complete. It will look something like:

> digitalocean_droplet.streaming (local-exec): TASK [streaming : What Now?]
>
> digitalocean_droplet.streaming (local-exec): ok: [192.168.1.143] => {
>
> digitalocean_droplet.streaming (local-exec): "msg": [
>
> digitalocean_droplet.streaming (local-exec): "Stream to rtmp://192.168.1.143:1935/stream/hello",

`rtmp://192.168.1.143:1935/stream/` is the stream url and `hello` is the key you'll use in your local streaming software.

Note: `hello` is just a placeholder and can be changed to anything you'd like.

### How to Watch

Once your live stream is started from your local streaming software it will appear on your chosen platforms; your Facebook timeline, Youtube channel and Twitch channel.

[![Buy me a coffee!](https://cdn.buymeacoffee.com/buttons/default-orange.png)](https://www.buymeacoffee.com/mikeydiamonds)
