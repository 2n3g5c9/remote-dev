# `remote-dev` (on GCP)

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/2n3g5c9/remote-dev/master.svg)](https://results.pre-commit.ci/latest/github/2n3g5c9/remote-dev/master)
[![Packer](https://github.com/2n3g5c9/remote-dev/actions/workflows/packer.yml/badge.svg)](https://github.com/2n3g5c9/remote-dev/actions/workflows/packer.yml)
[![Terraform](https://github.com/2n3g5c9/remote-dev/actions/workflows/terraform.yml/badge.svg)](https://github.com/2n3g5c9/remote-dev/actions/workflows/terraform.yml)

Automate the provisioning of an ephemeral development server on [Google Cloud Platform](https://cloud.google.com/).
An immutable image is built with [Packer](https://packer.io/) and deployed on an `e2-micro`
[Compute Engine](https://cloud.google.com/compute) instance (in `us-east1-b` to fall in the free tier) with
[Terraform](https://www.terraform.io/), all via [Cloud Build](https://cloud.google.com/cloud-build).
The instance is only accessible via SSH and MOSH in your [Tailscale](https://tailscale.com/) network.

## Diagram

<p align="center">
    <img src="https://raw.githubusercontent.com/2n3g5c9/remote-dev/master/img/diagram.png" alt="diagram" width="838px"/>
</p>

## Usage

### ✅ Prerequisites

#### 🔐 Generate your SSH key pair

If you don't have an SSH key pair already, generate one (preferably with a high-entropy passphrase):

```bash
ssh-keygen -o -a 100 -t ed25519 -C remote-dev
```

#### 👷‍♂️ Setup Cloud Build

Run the setup script to set the permissions to call the services APIs and setup Packer/Terraform:

```bash
./run.sh -s
```

### ⚙️ Build the machine image

In the `remote-dev` repository, submit the Packer **Cloud Build** job:

```bash
./run.sh -p
```

### 🚀 Deploy the server

In `remote-dev/terraform/env/prod/terraform.tfvars`, replace the SSH user/public key and Tailscale machines IP addresses
with your own values.

Generate a [Tailscale ephemeral key](https://login.tailscale.com/admin/settings/authkeys) and set it:

```bash
export TAILSCALE_KEY="tskey-xxx"
```

Then in the `remote-dev` repository, submit the Terraform **Cloud Build** jobs:

```bash
./run.sh -t
```

Once deployed, you can set explicit [Tailscale ACLs](https://login.tailscale.com/admin/acls) like the following to
restrict network access in your mesh:

```json
{
  "Hosts": {
    "remote-dev": "INSERT_IP_ADDRESS_HERE"
  },
  "ACLs": [
    { "Action": "accept", "Users": ["INSERT_USERNAME_HERE"], "Ports": ["remote-dev:22,60000-61000"] }
  ]
}
```

### 💥 Destroy the server

In the `remote-dev` repository, submit the Terraform Destroy **Cloud Build** jobs:

```bash
./run.sh -d
```

## About

### 🧰 Tech/frameworks used

- [Google Cloud Build](https://cloud.google.com/cloud-build): A service to "Continuously build, test, and deploy".
- [Packer](https://www.packer.io/): A tool to "Build Automated Machine Images".
- [Terraform](https://www.terraform.io/): A tool to "Write, Plan, and Create Infrastructure as Code".
- [Tailscale](https://tailscale.com/): A zero config WireGuard mesh VPN.

### 📃 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
