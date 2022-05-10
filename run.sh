#!/usr/bin/env bash

set -eufo pipefail

export PROJECT_ID="remote-dev-257323"
export TERRAFORM_VERSION="1.1.9"
export TERRAFORM_VERSION_SHA256SUM="9d2d8a89f5cc8bc1c06cb6f34ce76ec4b99184b07eb776f8b39183b513d7798a"

usage(){
  echo "Usage: ./run.sh [-s setup] [-p packer] [-t terraform] [-d destroy] [-h help]"
  exit 0
}

if [ $# -lt 1 ]; then
  usage
fi

setup=false;packer=false;terraform=false;destroy=false
while getopts 'sptdh' opt; do
    case "${opt}" in
        s) setup=true;;
        p) packer=true;;
        t) terraform=true;;
        d) destroy=true;;
        h) usage;;
        ?) usage;;
    esac
done

if [ "$setup" = true ]; then
  echo '👷‍ Setting up Cloud Build'
  ./set_acls.sh "${PROJECT_ID}"
  (cd cloud-builders-community/packer; gcloud builds submit)
  (cd cloud-builders-community/terraform; gcloud builds submit --substitutions=_TERRAFORM_VERSION="${TERRAFORM_VERSION}",_TERRAFORM_VERSION_SHA256SUM="${TERRAFORM_VERSION_SHA256SUM}")
fi

if [ "$packer" = true ]; then
  echo '⚙️ Building the machine image'
  (cd packer; gcloud builds submit)
fi

if [ "$terraform" = true ]; then
  echo '🚀 Deploying the server'
  (cd terraform/states; gcloud builds submit)
  (cd terraform; gcloud builds submit --substitutions=_TAILSCALE_KEY="${TAILSCALE_KEY}")
fi

if [ "$destroy" = true ]; then
  echo '💥 Destroying the server'
  (cd terraform; gcloud builds submit --config=cloudbuild-destroy.yaml)
  (cd terraform/states; gcloud builds submit --config=cloudbuild-destroy.yaml)
fi
