#
# nix flake check --no-build github:denver-cfman/nixos-micro-pi-cluster?ref=main
# nix flake show --no-build github:denver-cfman/nixos-micro-pi-cluster?ref=main
#
{
  description = "Flake for building a Raspberry Pi Zero 2 SD image";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    #colmena.url = "github:zhaofengli/colmena";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    #colmena,
    nixos-hardware
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
        inherit nixos-hardware inputs;
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


        };
      };
    };
}
