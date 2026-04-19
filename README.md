# nixos systems
---

---
### check this flake
```
nix flake check -v -L --no-build --no-write-lock-file --all-systems --refresh github:denver-cfman/nixos-systems?ref=main
```

### show this flake
```
nix flake show --all-systems --json --refresh github:denver-cfman/nixos-systems?ref=main | jq '.'
```

| System | Notes |
|---|---|
| [ha-console1](./ha-console1/README.md) | Home Assistant Wall Console 1 |
| [nixos-iMac](./nixos-iMac/README.md) | iMac nix Build System |
| [MacBookPro-nixos](./MacBookPro-nixos/README.md) | Old MacBookPro |
