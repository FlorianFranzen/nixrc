# AGENTS.md: the nixrc fleet

<!-- Written by `fleetl agents sync` from the fleet's metadata (host.nix,
service.nix, user.nix and mkFlake's arguments). Edit those, not this
file: the fleet-agents check fails while it is stale. -->

This repository is the NixOS fleet **nixrc** (`github:FlorianFranzen/nixrc`), laid out
for ftl: `ftl.lib.mkFlake` in `flake.nix` turns every folder into flake
outputs. Every host also carries its own part of this file as
`/etc/AGENTS.md`, with what its configuration adds.

## Layout

- `nixos/hosts/<host>/`: one folder per host. `host.nix` is metadata (a
  plain attribute set, never a module): `system`, `importance`, `layers`,
  `smartcard`, plus free-form data such as `fqdn`. Every other `.nix` file
  there is a module of that host; `*.pub` files are its public keys.
- `nixos/services/<service>/`: modules imported on the hosts its
  `service.nix` names; moving a service is editing that list.
- `nixos/modules/`: imported into every host; `nixos/profiles/`: opt-in
  building blocks (the `profiles` argument).
- `nixos/layers/<layer>.nix`: Nix profiles updated without a system
  rebuild; `ftl-layers.json` pins their revisions.
- `home/`: home-manager modules, profiles and variants; configurations
  are named `<base>-<variant>`.
- `users/<user>/`: `user.nix` (where the user has an account) and
  `ssh.pub` (the keys for login, sudo and deploying).
- `pkgs/`: own packages and the overlay; `static/`: files the modules
  reference as `static.<name>`.

## Working here

- Nix sees only files known to git: `git add` new files (intent-to-add,
  `git add -N`, is enough).
- Check a change with `nix flake check`, or one host with `nix build
  .#nixosConfigurations.<host>.config.system.build.toplevel`.
- Generated files are never edited by hand: `.sops.yaml` (`fleetl secrets
  sync`), `AGENTS.md` (`fleetl agents sync`) and `ftl-layers.json`
  (written by the build pipeline). `fleetl` is `nix run .#fleetl -- ...`.
- Secrets live in sops stores (`secrets.yaml`, `identity.yaml`) next to
  what they belong to. Never decrypt one into the working tree, print a
  secret, or commit plaintext; `fleetl secrets edit <store>` opens one.
- Hosts change through this repository, not by hand: what is deployed is
  what the branch says, and changes made on a machine are lost with the
  next deployment.

## Hosts

| host | system | importance | services | layers | users | hardware key |
| --- | --- | --- | --- | --- | --- | --- |
| `fawkes` | x86_64-linux | required | - | `gaming`, `cad` | `florian` | none registered |
| `hull` | x86_64-linux | optional | - | - | `florian` | none registered |
| `installer-aarch64` | aarch64-linux | optional | - | - | `florian` | none registered |
| `installer-x86_64` | x86_64-linux | optional | - | - | `florian` | none registered |
| `lovelace` | x86_64-linux | required | - | `gaming` | `florian` | none registered |
| `patterson` | aarch64-linux | required | - | - | `florian` | none registered |
| `pavlov` | x86_64-linux | required | `forge` | - | `florian` | none registered |
| `tesla` | x86_64-linux | ignored | - | - | `florian` | none registered |
| `torvalds` | x86_64-linux | optional | - | - | `florian` | none registered |

A `required` host that fails to build blocks the update of the fleet, an
`optional` one does not, and an `ignored` one is not built.

Layers are installed and rolled back on a host with `ftl-layers update |
list | rollback <layer>`, never with `nix-env`.

## Hardware keys

Keys are used for SSH logins, sudo, commit signing and, on build hosts,
signing the binary cache. On an **attended** host a person is there to
touch the key when asked; on a **headless** one nobody is, and its key
works without touch. Hosts without registered readers leave smartcards
alone.

- **Never guess a PIN or retry one in a loop.** A PIV PIN has three tries,
  and cards provisioned with mind-the-gap have their PUK blocked: a blocked
  PIN means provisioning the card again. When a PIN is needed, the user
  types it.
- **Never reset, provision or rewrite a card** (`mind-the-gap ... upload`,
  `ykman piv reset`, `ykman piv keys generate`, `ykman openpgp reset`,
  `nix-piv-provision`, admin commands in `gpg --card-edit`) unless the user
  asked for exactly that, for a card they named by its serial. Never pick
  whatever card is plugged in (`$(ykman list --serials)`).
- Prefer probes that spend no PIN and need no touch: `opensc-tool -l`,
  `ykman list`, `gpg-card list --cards`, `mind-the-gap cards`.
- **gpg's scdaemon holds every reader exclusively** for as long as it runs.
  After gpg used a card, `gpgconf --kill scdaemon` before PIV tools (ssh
  through PKCS#11, ykman, OpenSC, nix-piv); "other connections
  outstanding", or a card that seems gone, usually means this.
- Signing a commit, pushing, or connecting to a host may need the user's
  key, and so their PIN or touch: say so before starting, run it in the
  foreground, and do not retry a failed signature on your own.

## Binary caches

- http://pavlov:8080/cache, served by `pavlov`, signed by `pavlov-1:6S3Kv1gWT/xoWcm0cRyz91M8JeGoD0oCD+T0SfamjVM=`

## Services

| service | hosts | layers |
| --- | --- | --- |
| `forge` | `pavlov` | - |

## Users

| user | admin | hosts | services |
| --- | --- | --- | --- |
| `florian` | yes | all | - |

Accounts are key-only. sudo authenticates against the SSH agent the user
forwards (pam_rssh): it fails without one, and with a touch-policy key it
needs a touch.

The hosts' Nix daemons trust nobody but root (unless a host sets
`fleet.nix.trustWheel`). Closures the fleet's builder built carry the
cache's signature and copy as they are. One built elsewhere is pushed
through sudo first, which needs the forwarded agent (and a touch):

```
nix copy --no-check-sigs --to 'ssh-ng://<host>?remote-program=sudo%20nix-daemon' <path>
```

`nixos-rebuild --target-host <host> --sudo` or deploy-rs then find the
paths in place.
