<div align="center">
  <img width="512" src="https://raw.githubusercontent.com/2n3g5c9/remote-dev/master/img/remote-dev_banner.png" alt="remote-dev">
</div>

<br />

<div align="center">Configuration files to bootstrap a remote development box on GCP</div>

<br />

## Prerequisites

The configuration files in this repository help automating the provisioning of a development server on **Google Cloud Platform**. An image is built with [Packer](https://packer.io/) and deployed on an `f1-micro` **Compute Engine** instance with [Terraform](https://www.terraform.io/), all via **Cloud Build**, falling in the free-tier.

### Initialize the project

Open **Cloud Shell** and initialize the project:

```bash
export PROJECT_ID="PUT_YOUR_PROJECT_ID_HERE"
gcloud config set project $PROJECT_ID
```

### Set the required permissions

Run the permissions script to be able to call the services APIs:

```bash
./set_acls.sh
```

### Setup Cloud Build

Clone the `cloud-builders-community` repository:

```bash
mkdir gcloud && cd gcloud
git clone https://github.com/GoogleCloudPlatform/cloud-builders-community.git && cd cloud-builders-community
```

In the `packer` directory, setup Packer for **Cloud Build**:

```bash
(cd packer; gcloud builds submit)
```

In the `terraform` directory, setup Terraform for **Cloud Build**:

```bash
(cd terraform; gcloud builds submit)
```

## How to build the image

In the `packer` directory, submit the **Cloud Build** job:

```bash
(cd packer; gcloud builds submit)
```

## How to deploy the server

In the `terraform` directory, submit the **Cloud Build** job:

```bash
(cd terraform; gcloud builds submit)
```

## Tech/frameworks used

- [Packer](https://www.packer.io/): A tool to "Build Automated Machine Images".
- [Terraform](https://www.terraform.io/): A tool to "Write, Plan, and Create Infrastructure as Code".

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details