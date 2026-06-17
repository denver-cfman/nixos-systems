#
#
{
  description = "Flake for Giezen Consulting NixOS Systems";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    #colmena.url = "github:zhaofengli/colmena";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      # Ensure home-manager uses the same nixpkgs as your system for consistency.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arion.url = "github:hercules-ci/arion";
    arion.inputs.nixpkgs.follows = "nixpkgs";
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    #colmena,
    nixos-hardware,
    home-manager,
    arion,
    disko,
    sops-nix,
    hermes-agent
  }@inputs:
    let
      # see https://github.com/NixOS/nixpkgs/issues/154163
      overlays = [
        (final: super: {
          makeModulesClosure = x:
            super.makeModulesClosure (x // { allowMissing = true; });
        })
      ];
      specialArgs = {
        inherit inputs nixos-hardware home-manager arion disko hermes-agent;
      };
    in rec {
      nixosConfigurations = {
         hermes-test1 = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = overlays; })
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            hermes-agent.nixosModules.default
            ./hermes-test1/hermes-test1.nix
          ];
        };
         pine64-plus = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          #system = "aarch64-linux";
          system = "x86_64-linux";
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = overlays; })
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
            #"${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            #"${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
            sops-nix.nixosModules.sops
            arion.nixosModules.arion
            ./pine64-plus/pine64-plus.nix
          ];
        };
         nsfw-node1 = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = overlays; })
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            arion.nixosModules.arion
            ./nsfw-node1/nsfw-node1.nix
          ];
        };
         remote-nas1 = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = overlays; })
            ./remote-nas1/remote-nas1.nix
          ];
        };
         nixos-iMac = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = overlays; })
            ./nixos-iMac/nixos-iMac.nix
          ];
        };
         MacBookPro-nixos = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = overlays; })
            ./MacBookPro-nixos/MacBookPro-nixos.nix
          ];
        };
         ha-console1 = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = overlays; })
            ./ha-console1/ha-console1.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.giezac = import ./ha-console1/giezac.nix;
              
              # Optionally pass extra arguments to your home.nix
              home-manager.extraSpecialArgs = { inherit inputs; }; 
            }
          ];
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      deploy = {
        user = "root";
        sshOpts = [ "-i" "/home/giezac/.ssh/pzw2.rsa" ];
        interactiveSudo = true;        
        # Timeout for profile activation.
        # This defaults to 240 seconds.
        activationTimeout = 600;
      
        # Timeout for profile activation confirmation.
        # This defaults to 30 seconds.
        confirmTimeout = 90;
        nodes = {
          nsfw-node1 = {
            hostname = "nsfw-node1";
            profiles.system.path =
              deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.nsfw-node1;
            #remoteBuild = true;
          };
          remote-nas1 = {
            hostname = "remote-nas1";
            profiles.system.path =
              deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.remote-nas1;
            #remoteBuild = true;
          };
          nixos-iMac = {
            hostname = "nixos-iMac";
            profiles.system.path =
              deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nixos-iMac;
            #remoteBuild = true;
          };
          MacBookPro-nixos = {
            hostname = "MacBookPro-nixos";
            profiles.system.path =
              deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.MacBookPro-nixos;
            #remoteBuild = true;
          };
          ha-console1 = {
            hostname = "ha-console1";
            profiles.system.path =
              deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ha-console1;
            #remoteBuild = true;
          };
        };
      };
    };
}
