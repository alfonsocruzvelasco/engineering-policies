✅ That’s a *great* question — and shows a true **DevOps** mindset. Here’s a no-nonsense, professional summary of **best practices** for using `kind` on your Fedora RAID system while keeping it *clean, consistent, and maintainable*:

---

# 🚀 **1️⃣ Isolate `kind` from critical Docker containers**

* `kind` uses the same Docker daemon as your other projects
* Always name your kind clusters clearly (e.g., `devcluster`, `testcluster`)
* Avoid generic names so you don’t confuse them with production containers
* List containers regularly with:

  ```bash
  docker ps -a
  ```

  so you see what is `kind` versus your personal Docker containers.

---

# 🚀 **2️⃣ Clean up after kind clusters**

**When you finish developing with a cluster**:

* delete it to reclaim space:

  ```bash
  kind delete cluster --name devcluster
  ```
* this removes all the control-plane containers and their volumes
* you can always re-create it fresh in seconds with `kind create cluster`
* don’t leave 10 half-finished clusters running or they’ll eat disk and confuse you

---

# 🚀 **3️⃣ Monitor your Docker storage usage**

Since `kind` uses Docker images:

* prune images from time to time:

  ```bash
  docker system prune -a
  ```

  **careful**: this removes *all* stopped containers and dangling images, which is usually fine on a dev box
* check disk usage on your Docker volume (`/var/lib/docker`) with:

  ```bash
  docker system df
  ```
* since you have RAID, you’re safe on data loss, but still good to monitor space.

---

# 🚀 **4️⃣ Keep your kubeconfigs organized**

* `kind` updates `~/.kube/config`
* back it up sometimes, or version it (if you store cluster roles there)
* if you manage multiple clusters, you can view them all with:

  ```bash
  kubectl config get-contexts
  ```
* remove unused contexts so you don’t point `kubectl` to a dead cluster by mistake:

  ```bash
  kubectl config delete-context NAME
  ```

---

# 🚀 **5️⃣ Separate production from experiments**

**Never**:

* run “serious” production workloads inside `kind`
* store valuable databases or volumes in kind
  → keep kind purely for testing, local dev, and scratch deployments
  If you *really* need production Kubernetes, then you’d set up kubeadm or a hosted service (EKS, AKS, GKE, etc).

---

# 🚀 **6️⃣ Periodically update kind + kubectl**

Because Kubernetes moves fast:

* check for new kind releases:

  ```bash
  kind --version
  ```

  and reinstall if needed
* same for kubectl:

  ```bash
  kubectl version --client
  ```
* updating these tools is easier than trying to fix strange compatibility errors later

---

# 🚀 **7️⃣ Automate**

If you’re repeating the same cluster setup:

* store your manifests in Git
* use a Makefile or simple shell script to:

  * create the cluster
  * apply manifests
  * destroy the cluster
    → so you get consistent, reproducible environments every time

---

# ✅ **In short, the professional DevOps best practices are:**

✅ treat kind clusters as *ephemeral*, not precious
✅ delete them after use
✅ monitor your Docker space
✅ keep your kubeconfig tidy
✅ update kind and kubectl regularly
✅ automate with scripts
✅ don’t mix critical production workloads with kind

---

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
