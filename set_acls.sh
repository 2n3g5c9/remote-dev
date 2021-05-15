#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Make sure a PROJECT_ID is passed
if [ $# != 1 ]; then
    echo "Usage: $0 PROJECT_ID"
    exit 1
fi

# Set variables
readonly PROJECT_ID="$1"
CLOUD_BUILD_ACCOUNT=$(gcloud projects get-iam-policy "$PROJECT_ID" --filter="(bindings.role:roles/cloudbuild.builds.builder)" --flatten="bindings[].members" --format="value(bindings.members[])")
readonly CLOUD_BUILD_ACCOUNT

# Set project
gcloud config set project "${PROJECT_ID}"

# Enable services
gcloud services enable compute
gcloud services enable container
gcloud services enable sourcerepo.googleapis.com
gcloud services enable cloudapis.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable servicemanagement.googleapis.com
gcloud services enable storage-api.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Set permissions
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member "${CLOUD_BUILD_ACCOUNT}" \
  --role roles/editor
