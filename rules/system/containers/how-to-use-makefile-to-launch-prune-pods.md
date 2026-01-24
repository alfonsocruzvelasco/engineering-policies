# Kind DevCluster Makefile Guide

This Makefile provides an automated workflow to manage local Kubernetes clusters using [kind](https://kind.sigs.k8s.io) for development and testing.

## Commands

### `make kind-up`

- Creates a kind Kubernetes cluster named `devcluster`
- Uses the `kind-config.yaml` file to define the cluster (multi-node by default)
- Sets your kube context to the new cluster
- Creates a Kubernetes namespace `dev`

### `make kind-down`

- Deletes the `devcluster` and cleans up all associated kind containers

### `make kind-deploy`

- Applies the Kubernetes manifests found in `release/kubernetes-manifests.yaml`
- Deploys them into the `dev` namespace

### `make kind-pods`

- Lists pods running in the `dev` namespace

### `make kind-nodes`

- Lists the cluster nodes

### `make kind-context`

- Shows the current kubectl context

### `make restart`

- Prompts you to enter a Deployment name and restarts its rollout

### `make kind-reset`

- Combines kind-down, kind-up, and kind-deploy
- A quick way to rebuild everything from scratch

### `make docker-prune`

- Runs `docker system prune -af` to clean up dangling Docker images, stopped containers, and unused volumes

## Recommended Workflow

1. Spin up the cluster:

    ```bash
    make kind-up
    ```

2. Deploy your app:

    ```bash
    make kind-deploy
    ```

3. Check running pods:

    ```bash
    make kind-pods
    ```

4. Tear down when done:

    ```bash
    make kind-down
    ```

5. Clean Docker storage (optional):

    ```bash
    make docker-prune
    ```

## Notes

- The namespace is set to `dev` by default, change it in the Makefile if needed.
- The cluster name is `devcluster` by default, also customizable in the Makefile.
- `kind-config.yaml` defines a control-plane + 2 workers by default with port 30080 mapped.

## Requirements

- Docker
- kind
- kubectl
- GNU Make
