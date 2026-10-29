# Handover

What is left on nixrc after the move to ftl's fleet modules (2026-10-29).
ftl's own notes are in its `HUMAN.md`; nix-piv's in its `HUMAN.md` and README.

## Smartcard readers

No reader is registered yet, so `fleet.smartcard` is off everywhere. Once a
reader is registered for a host, pcscd there ignores every other CCID device:
register every key in use (YubiKey, Nitrokey, Ledger, Solo 2), or none.

- fawkes, lovelace and hull: attended, the keys as fleet-wide readers
  (`smartcard.readers` in `flake.nix`).
- pavlov: headless, its builder card only (`smartcard` in its host.nix with
  `presence = "headless"; fleetReaders = false;`, matched by port).

The ids, with the keys plugged in:

```
for d in /sys/bus/usb/devices/*; do
  [ -f "$d/idVendor" ] && echo "$(basename "$d") $(cat "$d/idVendor"):$(cat "$d/idProduct") $(cat "$d/product" 2>/dev/null)"
done
```

The first column is the port, the second vendor:product. Once the readers are
registered, drop the touch detector from
`nixos/profiles/hardware/smartcard.nix` (ftl turns it on for attended hosts);
`disable-ccid` in `home/profiles/desktop/gnupg.nix` repeats what ftl sets.

## pavlov, the card-backed builder

The pipeline is meant to push, sign commits and reach remote builders with a
card nobody touches. Prepared in the worktree `~/Nix/nixrc-piv-builder`
(branch `piv-builder`, staged, not committed, behind `master`: redo it on
`master`). Steps:

1. **Provision the builder card** (a YubiKey 4). Either air-gapped with
   mind-the-gap (variant A, keys from a seed) or on pavlov (variant B, keys
   made on the card); nix-piv's README has both. Variant B resets the PIV
   application, so run it only with the builder card plugged in, nothing else:

   ```
   nix run github:FlorianFranzen/nix-piv#nix-piv-provision -- --reader 'Yubico YubiKey' --name pavlov-builder
   ```

2. **On pavlov, read the public keys and seal the PIN:**

   ```
   nix run github:FlorianFranzen/nix-piv#nix-piv -- pubkeys --principal pavlov-builder --key-name pavlov-card-1
   sudo nix run github:FlorianFranzen/nix-piv#nix-piv-seal-pin   # writes /var/lib/piv-agent/pin.cred
   ```

   pavlov has no TPM, so the PIN is sealed to the host key.
3. **In nixrc:** lock nix-piv, add `nix-piv.nixosModules.agent` to
   `nixos.sharedModules`, register pavlov's reader (above), and put the four
   lines of `pubkeys` into `nixos/modules/builder-card.nix` (from the
   `piv-builder` worktree). `fleet.smartcard` then turns on nix-piv's agent on
   pavlov and gives the pipeline its socket. Drop the hand-written
   `services.piv-agent` settings.
4. **Deploy pavlov**, then `sudo -u ftl SSH_AUTH_SOCK=/run/piv-agent-shared/agent.sock ssh-add -l`
   lists the card's keys.

## The forge's cache

The forge announces its cache in `nixos/services/forge/service.nix`; every
other host substitutes from it and gets `ftl-status`. ftl does not turn on gc
(`fleet.client.gc.automatic`).
