# ha-console1
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
sudo nixos-rebuild switch --refresh --flake github:denver-cfman/nixos-systems?ref=main#ha-console1
```
#### deploy-rs
```
K3S_TOKEN=thisisjustatest nix run github:serokell/deploy-rs github:denver-cfman/nixos-systems?ref=main#ha-console1 -- -s -d --ssh-user giezac --hostname 10.0.81.99
```

#### Test Compile of a single package
```
nix build github:NixOS/nixpkgs/e4f449ab51a283676d3b520c3dbaa3eafa5025b4#pkgsCross.aarch64-multiplatform.screen
```
