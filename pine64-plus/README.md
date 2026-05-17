# [pine64-plus](https://nixos.wiki/wiki/NixOS_on_ARM/PINE64_Pinebook)
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
sudo nixos-rebuild switch --impure --refresh --flake github:denver-cfman/nixos-systems?ref=main#pine64-plus --no-write-lock-file
```
#### deploy-rs
```
K3S_TOKEN=thisisjustatest nix run github:serokell/deploy-rs github:denver-cfman/nixos-systems?ref=main#pine64-plus -- -s -d --ssh-user giezac --hostname 10.0.81.99
```
#### Build sd-image (for flashing on [Pine64+](https://discourse.nixos.org/t/pine64-device-images/15699))
```
sudo nix build --impure --refresh --rebuild --no-update-lock-file -L -v github:denver-cfman/nixos-systems?ref=main#nixosConfigurations.pine64-plus.config.system.
build.sdImage
```

#### nix-tree view
```
nix run nixpkgs#nix-tree -- github:denver-cfman/nixos-systems#nixosConfigurations."pine64-plus".config.system.build.toplevel --derivation --impure
```

#### eval compose yaml
```
nix eval --impure --refresh "github:denver-cfman/nixos-systems?ref=main#nixosConfigurations.pine64-plus.config.virtualisation.arion.projects.arion-container-stack.settings.out.dockerComposeYamlAttrs" --json | jq '.'
```

#### Test Compile of a single package
```
nix build github:NixOS/nixpkgs/e4f449ab51a283676d3b520c3dbaa3eafa5025b4#pkgsCross.aarch64-multiplatform.screen
```
