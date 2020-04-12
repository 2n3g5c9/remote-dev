<div align="center">
  <img width="512" src="https://raw.githubusercontent.com/2n3g5c9/remote-dev/master/img/remote-dev_banner.png" alt="remote-dev">
</div>

<br />

<div align="center">Configuration files to bootstrap a remote development server on GCP</div>

<br />

## Prerequisites

The configuration files in this repository help automate the provisioning of a development server on **Google Cloud Platform**. An image is built with [Packer](https://packer.io/) and deployed on an `f1-micro` **Compute Engine** instance with [Terraform](https://www.terraform.io/), all via **Cloud Build**, falling in the free-tier.

### Initialize the project

Open **Cloud Shell** and initialize the project:

```bash
export PROJECT_ID="PUT_YOUR_PROJECT_ID_HERE"
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
(cd terraform; gcloud builds submit --substitutions=_TERRAFORM_VERSION="0.12.24",_TERRAFORM_VERSION_SHA256SUM="602d2529aafdaa0f605c06adb7c72cfb585d8aa19b3f4d8d189b42589e27bf11")
```

## How to build the image

In the `remote-dev` repository, submit the following **Cloud Build** job:

```bash
(cd packer; gcloud builds submit)
```

## How to deploy the server

In the `remote-dev` repository, submit the following **Cloud Build** jobs:

```bash
(cd terraform/states/; gcloud builds submit)
(cd terraform/; gcloud builds submit)
```

## How to destroy the server

In the `remote-dev` repository, submit the following **Cloud Build** jobs:

```bash
(cd terraform/; gcloud builds submit --config=cloudbuild-destroy.yaml)
(cd terraform/states/; gcloud builds submit --config=cloudbuild-destroy.yaml)
```

## Tech/frameworks used

- [Google Cloud Build](https://cloud.google.com/cloud-build): A tool to "Continuously build, test, and deploy".
- [Packer](https://www.packer.io): A tool to "Build Automated Machine Images".
- [Terraform](https://www.terraform.io): A tool to "Write, Plan, and Create Infrastructure as Code".

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
