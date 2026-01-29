provider "google" {
  project = "my-rd-ce-horng-lee"
  region  = "asia-southeast1"
}

# 1. Create the Artifact Registry Repository
resource "google_artifact_registry_repository" "my_repo" {
  location      = "asia-southeast1"
  repository_id = "my-repo"
  description   = "Docker repository"
  format        = "DOCKER"
}

# 2. Grant Cloud Build permission to Deploy to Cloud Run
# (Cloud Build uses a special Service Account; we must give it power)
data "google_project" "project" {}

resource "google_project_iam_member" "cloudbuild_roles" {
  for_each = toset([
    "roles/run.admin",                # Allow deploying to Cloud Run
    "roles/iam.serviceAccountUser"    # Allow acting as a service account
  ])
  project = data.google_project.project.project_id
  role    = each.key
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# 3. Create the Cloud Build Trigger
# Note: You must have manually connected your GitHub repo to Google Cloud once before this works.
resource "google_cloudbuild_trigger" "filename-trigger" {
  name = "terraform-deploy-trigger"
  location = "global"
  github {
    owner = "ryanng-star"
    name  = "cicd-rnxy"
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml" # Looks for this file in your repo
}