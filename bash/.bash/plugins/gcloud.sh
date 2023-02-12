#!/usr/bin/env bash

function gcloud_project_id() {
  local -r NAME="${1:?Missing project name}"
  gcloud projects list --filter=name="$NAME" --format="value(projectId)"
}

function gcloud_project_number() {
  local -r NAME="${1:?Missing project name}"
  gcloud projects list --filter=name="$NAME" --format="value(projectNumber)"
}

function gcloud_project_info() {
  local -r NAME="${1:?Missing project name}"
  local -r PROJECT="$(gcloud projects list --filter=name="$NAME" --format=json)"
  if [ -z "$PROJECT" ]; then
    echo >&2 "Project not found: $NAME"
    return 1
  fi
  echo "PROJECT_ID=$(echo "$PROJECT" | jq -r '.[0].projectId | values')"
  echo "PROJECT_NAME=$(echo "$PROJECT" | jq -r '.[0].name | values')"
  echo "PROJECT_NUMBER=$(echo "$PROJECT" | jq -r '.[0].projectNumber | values')"
}

function gcloud_project_propagate_env() {
  local -r NAME="${1:?Missing project name}"
  local -r PROJECT="$(gcloud projects list --filter=name="$NAME" --format=json)"
  if [ -z "$PROJECT" ]; then
    echo >&2 "Project not found: $NAME"
    return 1
  fi
  export PROJECT_ID="$(echo "$PROJECT" | jq -r '.[0].projectId | values')"
  export PROJECT_NAME="$(echo "$PROJECT" | jq -r '.[0].name | values')"
  export PROJECT_NUMBER="$(echo "$PROJECT" | jq -r '.[0].projectNumber | values')"
  echo "PROJECT_ID=$PROJECT_ID"
  echo "PROJECT_NAME=$PROJECT_NAME"
  echo "PROJECT_NUMBER=$PROJECT_NUMBER"
}

function gcloud_config_propagate_env() {
  local -r ID="$(gcloud config get-value project 2>/dev/null)"
  if [ -z "$ID" ]; then
    echo >&2 "Missing project in config"
    return 1
  fi
  local -r PROJECT="$(gcloud projects list --filter=projectId="$ID" --format=json)"
  export PROJECT_ID="$(echo "$PROJECT" | jq -r '.[0].projectId | values')"
  export PROJECT_NAME="$(echo "$PROJECT" | jq -r '.[0].name | values')"
  export PROJECT_NUMBER="$(echo "$PROJECT" | jq -r '.[0].projectNumber | values')"
  export REGION="$(gcloud config get compute/region 2>/dev/null)"
  export ZONE="$(gcloud config get compute/zone 2>/dev/null)"
  echo "PROJECT_ID=$PROJECT_ID"
  echo "PROJECT_NAME=$PROJECT_NAME"
  echo "PROJECT_NUMBER=$PROJECT_NUMBER"
  echo "REGION=$REGION"
  echo "ZONE=$ZONE"
}
