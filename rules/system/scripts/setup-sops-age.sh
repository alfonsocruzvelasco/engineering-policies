#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing dependencies (age, sops)"
sudo dnf install -y age sops

echo "==> Creating SOPS age key directory"
mkdir -p "$HOME/.config/sops/age"
chmod 700 "$HOME/.config/sops"
chmod 700 "$HOME/.config/sops/age"

KEY_FILE="$HOME/.config/sops/age/keys.txt"

if [[ -f "$KEY_FILE" ]]; then
  echo "Key already exists at $KEY_FILE — skipping generation"
else
  echo "==> Generating age key"
  age-keygen -o "$KEY_FILE"
  chmod 600 "$KEY_FILE"
fi

echo "==> Configuring shell to use this key automatically"
if ! grep -q 'SOPS_AGE_KEY_FILE' "$HOME/.bashrc"; then
  echo 'export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"' >> "$HOME/.bashrc"
  echo "Added SOPS_AGE_KEY_FILE to ~/.bashrc"
else
  echo "SOPS_AGE_KEY_FILE already configured in ~/.bashrc"
fi

export SOPS_AGE_KEY_FILE="$KEY_FILE"

echo "==> Your public key is:"
grep -m1 '^# public key:' "$KEY_FILE" | sed 's/# public key: //'

echo "==> Running encryption test"
TEST_FILE="/tmp/sops-test.yaml"
ENC_FILE="/tmp/sops-test.enc.yaml"

echo "hello: world" > "$TEST_FILE"

PUB_KEY=$(grep -m1 '^# public key:' "$KEY_FILE" | awk '{print $4}')
sops --encrypt --age "$PUB_KEY" "$TEST_FILE" > "$ENC_FILE"

echo "Decrypted content:"
sops --decrypt "$ENC_FILE"

echo "==> SOPS + age setup complete"
