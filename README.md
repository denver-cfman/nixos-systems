# nixos systems
---

---
### check this flake
```
nix flake check -v -L --no-build --no-write-lock-file github:denver-cfman/nixos-systems?ref=main
```

### show this flake
```
nix flake show --all-systems --json github:denver-cfman/nixos-systems?ref=main | jq '.'
```

### remote update nix (nixos-rebuild) on cluster head
#### nixos-rebuild
```
sudo nixos-rebuild switch --flake github:denver-cfman/nixos-micro-pi-cluster#_8d4cb64d --target-host 10.0.85.10 --use-remote-sudo --build-host 10.0.81.242
```
#### deploy-rs
```
K3S_TOKEN=thisisjustatest nix run github:serokell/deploy-rs github:denver-cfman/nixos-micro-pi-cluster#_8d4cb64d -- -s -d --ssh-user giezac --hostname 10.0.85.10
```

#### Test Compile of a single package
```
nix build github:NixOS/nixpkgs/e4f449ab51a283676d3b520c3dbaa3eafa5025b4#pkgsCross.aarch64-multiplatform.screen
```
