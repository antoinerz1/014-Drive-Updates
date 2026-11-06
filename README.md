# 014-Drive — mises à jour du client ordinateur

Site statique publié sur Cloudflare Pages (projet `update-014drive`, compte Cloudflare dédié) :
https://update-014drive.pages.dev

- `site/latest.json` : dernière version, au format de `tauri-plugin-updater` (adresse et signature de l'installateur).
  L'application l'interroge toutes les 6 heures et installe d'elle-même toute version plus récente.
- `site/<version>/…` : installateur Windows et paquet Linux (.deb) signés ; `site/014-Drive-setup.exe` et
  `site/014-Drive_amd64.deb` : les mêmes à adresse fixe, pour le bouton « Télécharger les applications » du site web.
  Pas de page d'accueil.

Ce dépôt n'est pas modifié à la main : à chaque étiquette `v*` du dépôt `014-Drive-Computer-Client`, sa CI construit
et signe l'installateur, régénère `site/` et le pousse ici (historique réduit à un seul commit pour ne pas accumuler
les installateurs). Le push déclenche le déploiement.

Secrets GitHub de ce dépôt : `CLOUDFLARE_API_TOKEN` (permission « Cloudflare Pages : Edit »), `CLOUDFLARE_ACCOUNT_ID`.
