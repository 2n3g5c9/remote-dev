# Remote development server

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

Setup Packer for **Cloud Build**:

```bash
(cd packer; gcloud builds submit)
```

Setup Terraform for **Cloud Build**:

```bash
(cd terraform; gcloud builds submit)
```

## How to build the image

In the `packer` directory, submit the **Cloud Build** job:

```bash
gcloud builds submit
```

## How to deploy the server

In the `terraform` directory, submit the **Cloud Build** job:

```bash
gcloud builds submit
```
