<div align="center">
  <img width="512" src="https://raw.githubusercontent.com/2n3g5c9/remote-dev/master/img/banner.png" alt="remote-dev">
</div>

<p align="center">
    <a href="#-diagram">Diagram</a>
    &nbsp; • &nbsp;
    <a href="#-prerequisites">Prerequisites</a>
    &nbsp; • &nbsp;
    <a href="#%EF%B8%8F-how-to-build-the-image">Build</a>
    &nbsp; • &nbsp;
    <a href="#-how-to-deploy-the-server">Deploy</a>
    &nbsp; • &nbsp;
    <a href="#-how-to-destroy-the-server">Destroy</a>
    &nbsp; • &nbsp;
    <a href="#-techframeworks-used">Tech/frameworks used</a>
    &nbsp; • &nbsp;
    <a href="#-license">License</a>
</p>

<p align="center">
    <a href="https://results.pre-commit.ci/latest/github/2n3g5c9/remote-dev/master" aria-label="pre-commit.ci details" target="_blank" rel="noopener noreferrer">
        <img src="https://results.pre-commit.ci/badge/github/2n3g5c9/remote-dev/master.svg" alt="pre-commit.ci status"/>
    </a>
    <a href="https://github.com/2n3g5c9/remote-dev/actions/workflows/terraform.yml">
        <img src="https://github.com/2n3g5c9/remote-dev/actions/workflows/terraform.yml/badge.svg" alt="terraform-badge"/>
    </a>
</p>

<p align="center">
    <img src="https://img.shields.io/github/languages/count/2n3g5c9/remote-dev.svg?style=flat" alt="languages-badge"/>
    <img src="https://img.shields.io/github/license/2n3g5c9/remote-dev" alt="license-badge">
    <img src="https://img.shields.io/github/repo-size/2n3g5c9/remote-dev" alt="repo-size-badge">
    <img src="https://img.shields.io/github/last-commit/2n3g5c9/remote-dev" alt="last-commit-badge">
    <img src="https://img.shields.io/github/issues-raw/2n3g5c9/remote-dev" alt="open-issues-badge">
</p>

## 🖼 Diagram

<p align="center">
    <img src="https://raw.githubusercontent.com/2n3g5c9/remote-dev/master/img/diagram.png" alt="diagram" width="838px"/>
</p>

## ✅ Prerequisites

This repository helps automate the provisioning of an ephemeral development server on
[Google Cloud Platform](https://cloud.google.com/). An immutable image is built with [Packer](https://packer.io/) and
deployed on an `f1-micro` (in `us-east1-b` to fall in the free-tier) [Compute Engine](https://cloud.google.com/compute)
instance with [Terraform](https://www.terraform.io/), all via [Cloud Build](https://cloud.google.com/cloud-build).
The instance is only accessible via SSH and MOSH in your [Tailscale](https://tailscale.com/) network. Keep in mind
you'll be charged for the External IP address.

### Generate your SSH key pair

If you don't have an SSH key pair already, generate one (preferably with a high-entropy passphrase):

```bash
ssh-keygen -o -a 100 -t ed25519 -C remote-dev
```

### Initialize the project

Open **Cloud Shell** and initialize the project:

```bash
export PROJECT_ID="INSERT_PROJECT_ID_HERE"
gcloud config set project $PROJECT_ID
```

### Set the required permissions

Run the permissions script to be able to call the services APIs:

```bash
./set_acls.sh $PROJECT_ID
```

### Setup Cloud Build

Clone the `cloud-builders-community` repository:

```bash
mkdir gcloud && cd gcloud
git clone https://github.com/GoogleCloudPlatform/cloud-builders-community.git && cd cloud-builders-community
```

In the `cloud-builders-community` repository, setup Packer for **Cloud Build**:

```bash
(cd packer; gcloud builds submit)
```

In the `cloud-builders-community` repository, setup Terraform for **Cloud Build**:

```bash
(cd terraform; gcloud builds submit --substitutions=_TERRAFORM_VERSION="0.15.4",_TERRAFORM_VERSION_SHA256SUM="ddf9b409599b8c3b44d4e7c080da9a106befc1ff9e53b57364622720114e325c")
```

## ⚙️ How to build the image

In the `remote-dev` repository, submit the following **Cloud Build** job:

```bash
(cd packer; gcloud builds submit)
```

## 🚀 How to deploy the server

In `remote-dev/terraform/env/prod/terraform.tfvars`, replace the SSH user/public key and Tailscale machines IP addresses
with your own values.

Generate a [Tailscale ephemeral key](https://login.tailscale.com/admin/settings/authkeys) and set it:

```bash
export TAILSCALE_KEY="tskey-XXX"
```

Then in the `remote-dev` repository, submit the following **Cloud Build** jobs:

```bash
(cd terraform/states; gcloud builds submit)
(cd terraform; gcloud builds submit --substitutions=_TAILSCALE_KEY="${TAILSCALE_KEY}")
```

Once deployed, you can set explicit [Tailscale ACLs](https://login.tailscale.com/admin/acls) like the following to
restrict network access in your mesh:

```json
{
  "Hosts": {
    "remote-dev": "INSERT_IP_ADDRESS_HERE"
  },
  "ACLs": [
    { "Action": "accept", "Users": ["INSERT_USERNAME_HERE"], "Ports": ["remote-dev:22,60000-60010"] }
  ]
}
```

## 🧨 How to destroy the server

In the `remote-dev` repository, submit the following **Cloud Build** jobs:

```bash
(cd terraform; gcloud builds submit --config=cloudbuild-destroy.yaml)
(cd terraform/states; gcloud builds submit --config=cloudbuild-destroy.yaml)
```

## 🪄 Tech/frameworks used

- [Google Cloud Build](https://cloud.google.com/cloud-build): A tool to "Continuously build, test, and deploy".
- [Packer](https://www.packer.io/): A tool to "Build Automated Machine Images".
- [Terraform](https://www.terraform.io/): A tool to "Write, Plan, and Create Infrastructure as Code".
- [Tailscale](https://tailscale.com/): A zero config WireGuard mesh VPN.

## 📃 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
