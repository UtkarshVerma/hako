# hako

This repository contains a declarative definition of my homelab using NixOS and
Docker.

## Usage

1. Symlink `nixos/` to `/etc/nixos/` and regenerate NixOS.
2. Copy `.env.template` to `.env` and populate it with secrets.
3. `docker compose up -d`

For backups, `backup.sh` and `restore.sh` scripts have been provided for
convenience.

> [!NOTE]
> For `ddclient`, the config must be specified in
> `services/ddclient/state/ddclient.conf`.
>
> For `wireguard`, put all configs in
> `services/qbittorent/state/wireguard/wg_confs`. In case of IPv6 errors
> ensure that `AllowedIPs` only contains `0.0.0.0/0`.
