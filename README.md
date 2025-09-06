FluxCD PoC Kubernetes Setup

This repository demonstrates a GitOps workflow for deploying a sample application (myapp) using FluxCD on Kubernetes. It uses Kustomize overlays for environment-specific configurations and automates deployment via FluxCD syncing from a GitHub repository.

Folder Structure
.
├── apps
│   └── myapp
│       ├── base
│       │   ├── deployment.yaml
│       │   ├── kustomization.yaml
│       │   └── service.yaml
│       └── overlays
│           └── production
│               ├── kustomization.yaml
│               └── configmap.yaml
├── clusters
│   └── fluxcd-poc-aks
│       ├── flux-system
│       │   ├── gotk-components.yaml
│       │   ├── gotk-sync.yaml
│       │   └── kustomization.yaml
│       ├── kustomization.yaml
│       ├── namespaces.yaml
│       └── ...
├── README.md
└── ...

Overview of Key Components
apps/myapp/base

Base Kubernetes manifests for the sample app:

deployment.yaml: Deployment manifest specifying the container image.

service.yaml: Service exposing the app.

kustomization.yaml: References these base resources.

apps/myapp/overlays/production

Production environment specific customizations:

configmap.yaml: Environment variables/configurations for the app.

kustomization.yaml: Pulls base resources and overlays configmap.

clusters/fluxcd-poc-aks

Cluster-level configuration:

namespaces.yaml: Namespace definitions.

kustomization.yaml: Applies namespaces and app overlays.

flux-system/: FluxCD system manifests and kustomizations.

Prerequisites

Kubernetes cluster (AKS or any Kubernetes cluster)

kubectl CLI installed and configured

FluxCD CLI (flux) installed

Docker Hub account (or container registry) with your app image pushed

GitHub repository for the manifests

Automated Image Build and Deployment via GitHub Actions and FluxCD

This setup uses GitHub Actions to automatically build, tag, and push the Docker image whenever changes are pushed to the repository. There is no manual step needed to build or push the container image.

How it works:

Code commit/push triggers GitHub Actions pipeline

The workflow runs steps to build the Docker image using the Dockerfile in your repository.

The image is tagged (for example, with the git commit SHA or latest).

The image is pushed to a container registry (like Docker Hub or ACR).

GitHub Actions updates Kubernetes manifests

The deployment manifest (deployment.yaml) in the repo is updated with the new image tag.

This ensures the manifests always reference the latest image built by the pipeline.

FluxCD watches the Git repository

FluxCD detects the manifest change.

It pulls the new manifest with the updated image tag.

FluxCD applies the updated manifests to your Kubernetes cluster, rolling out the new image version.

Benefits

Fully automated CI/CD pipeline: no manual builds or deployments.

GitOps model: Kubernetes manifests are the single source of truth in Git.

Automatic rollout of new app versions on container image update.

Deployment Steps
1. Prepare Your Application Manifests

Edit your application manifests under apps/myapp/base/ and apps/myapp/overlays/production/.

Build your Docker image for myapp and push it to your container registry.

2. Prepare Cluster Configuration

Ensure namespaces and cluster-specific kustomizations are defined under clusters/fluxcd-poc-aks/.

3. Bootstrap FluxCD

Run Flux bootstrap to install FluxCD in your cluster and connect it to your GitHub repo:

flux bootstrap github \
  --owner=YOUR_GITHUB_USERNAME \
  --repository=YOUR_REPO_NAME \
  --branch=main \
  --path=./clusters/fluxcd-poc-aks \
  --personal


This will install Flux components and start syncing resources defined under the specified path.

4. Verify FluxCD Components

Check Flux system components and confirm they are running:

kubectl get pods -n flux-system

5. Monitor Kustomizations

Check the status of kustomizations and ensure sync was successful:

flux get kustomizations

6. Verify Your Application Deployment

Check the namespace and pods for your app:

kubectl get ns
kubectl get pods -n myapp
kubectl get deployments -n myapp


Check pod logs for troubleshooting:

kubectl logs -n myapp <pod-name>

7. Make Changes and Test GitOps Flow

Modify manifests (e.g., update image tag in deployment.yaml).

Commit and push changes to GitHub.

FluxCD will detect the change and reconcile the cluster automatically.

Check status again with:

flux get kustomizations
kubectl rollout status deployment/myapp -n myapp

Troubleshooting

If pods crash or are not ready, check pod logs and events.

Ensure image tags and container registries are correctly accessible.

Validate paths in kustomization.yaml files.

Use flux logs and kubectl describe to inspect Flux or Kubernetes resources.

Summary

This GitOps setup demonstrates:

Declarative infrastructure as code via Kustomize.

Continuous reconciliation with FluxCD.

Environment overlays to separate production from other configs.

Easy updating and rollback by committing changes to GitHub.