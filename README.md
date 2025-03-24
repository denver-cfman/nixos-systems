# nixos systems
---

---
### check this flake
```
nix flake check -v -L --no-build --no-write-lock-file --all-systems github:denver-cfman/nixos-systems?ref=main
```

### show this flake
```
nix flake show --all-systems --json github:denver-cfman/nixos-systems?ref=main | jq '.'
```

| System | Notes |
|---|---|
| [remote-nas1](./remote-nas1/readme.md) | Test NAS System |
| [nixos-iMac](./nixos-iMac/readme.md) | Test iMac Build System |
