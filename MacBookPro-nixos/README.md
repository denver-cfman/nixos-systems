# MacBookPro-nixos
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

### remote update nix (nixos-rebuild) on cluster head
#### nixos-rebuild
```
sudo nixos-rebuild switch --no-write-lock-file --refresh --impure --flake github:denver-cfman/nixos-systems?ref=main#MacBookPro-nixos
```
#### deploy-rs
```
K3S_TOKEN=thisisjustatest nix run github:serokell/deploy-rs github:denver-cfman/nixos-systems?ref=main#MacBookPro-nixos -- -s -d --ssh-user giezac --hostname 10.0.81.99
```

#### Test Compile of a single package
```
nix build --impure github:NixOS/nixpkgs/bd3bac8bfb542dbde7ffffb6987a1a1f9d41699f#termius
```
