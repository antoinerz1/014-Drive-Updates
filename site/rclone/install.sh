#!/bin/sh
# Installation de 014drive-rclone sous Linux : curl -fsSL https://update-014drive.pages.dev/rclone/install.sh | sh
# Binaire dans /usr/local/bin (root) ou ~/.local/bin ; empreinte SHA-256 vérifiée. Mises à jour ensuite automatiques.
set -eu

BASE="https://update-014drive.pages.dev/rclone"
case "$(uname -m)" in
  x86_64 | amd64) PLATFORM=linux-x86_64 ;;
  aarch64 | arm64) PLATFORM=linux-aarch64 ;;
  *) echo "Architecture non prise en charge : $(uname -m)" >&2; exit 1 ;;
esac
if [ "$(id -u)" = "0" ]; then DEST=/usr/local/bin; else DEST="$HOME/.local/bin"; fi
mkdir -p "$DEST"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
curl -fsSL "$BASE/latest.json" -o "$TMP/latest.json"
# Empreinte attendue pour cette plateforme : premier « sha256 » de son bloc dans latest.json (sur plusieurs lignes)
SUM="$(tr -d '\n' < "$TMP/latest.json" | sed -n "s/.*\"$PLATFORM\": *{[^}]*\"sha256\": *\"\([0-9a-f]\{64\}\)\".*/\1/p")"
[ -n "$SUM" ] || { echo "Plateforme $PLATFORM absente de l'annonce de version" >&2; exit 1; }
curl -fsSL "$BASE/014drive-rclone-$PLATFORM" -o "$TMP/014drive-rclone"
echo "$SUM  $TMP/014drive-rclone" | sha256sum -c - >/dev/null || { echo "Empreinte incorrecte : installation annulée" >&2; exit 1; }
install -m 755 "$TMP/014drive-rclone" "$DEST/014drive-rclone"

echo "014drive-rclone installé dans $DEST ($("$DEST/014drive-rclone" --version))."
command -v rclone >/dev/null 2>&1 || echo "rclone n'est pas installé : https://rclone.org/install/ (curl https://rclone.org/install.sh | sudo bash)"
case ":$PATH:" in *":$DEST:"*) ;; *) echo "Ajoutez $DEST à votre PATH." ;; esac
echo "Ensuite : 014drive-rclone setup"
