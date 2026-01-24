✅ **Great — let’s go through Docker Compose clean-up best practices, clearly and professionally.**

---

# 🚀 **1️⃣ Stop and remove containers**

Inside your project folder (where the `docker-compose.yml` lives):

```bash
docker compose down
```

✅ This will:

* stop all running services
* remove their containers
* keep volumes **intact** (so your data stays)

---

# 🚀 **2️⃣ If you also want to remove volumes (wipe data)**

```bash
docker compose down -v
```

✅ This will:

* stop containers
* delete containers
* delete all named and anonymous volumes
  → **use with caution** if you want a full reset.

---

# 🚀 **3️⃣ Clean up dangling resources**

Over time, you might have:

* old images
* dangling containers
* unused volumes

You can prune them with:

```bash
docker system prune
```

⚠️ **CAREFUL** — this will remove:

* stopped containers
* dangling images
* unused networks

If you also want to prune volumes (deep clean):

```bash
docker system prune --volumes
```

---

# 🚀 **4️⃣ Check what’s using space**

Before pruning, you can check:

```bash
docker system df
```

---

# ✅ **Typical clean workflow**

**After working on a Compose project**:

```bash
docker compose down
```

**Periodically clean dangling data**:

```bash
docker system prune
```

✅ **That’s all you usually need** to keep Docker neat and performant.

---

# 🚀 **TL;DR**

✅ `docker compose down` → stop & remove containers
✅ `docker compose down -v` → also remove volumes
✅ `docker system prune` → global cleanup
✅ check with `docker system df`

---
