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
    home-manager = {
      url = "github:nix-community/home-manager";
      # Ensure home-manager uses the same nixpkgs as your system for consistency.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    #colmena,
    nixos-hardware,
    home-manager
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
        inherit inputs nixos-hardware home-manager;
      };
    in rec {
      nixosConfigurations = {
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
