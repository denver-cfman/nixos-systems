{ config, pkgs, lib, inputs, ... }:

let
  vncPassword = builtins.getEnv "VNC_PW";
  finalVncPw = if vncPassword != "" then vncPassword else "password";

  torbImageTag = builtins.getEnv "TORB_IMAGE_TAG";
  finalTorbImageTag = if torbImageTag != "" then torbImageTag else "aarch64-1.17.0-rolling-daily";
in
{
  virtualisation.arion = {
    backend = "podman-socket";
    projects.arion-container-stack = {
      settings = {
        # 1. Global Declaration (Forces the 'networks:' header in YAML)
        docker-compose.raw.networks.nsfw-network = {
            name = "NSFW";
            external = true;
        };

        services.nsfw-browser = {
          # 2. Assign the service to the network
          # This must be outside the 'service' block for some Arion versions
          # or defined as an attribute set for better compatibility.
          networks.nsfw-network = {};

          service = {
            image = "kasmweb/tor-browser:" + finalTorbImageTag;
            environment = {
              VNC_PW = finalVncPw;
              HTTP_PROXY = "http://10.0.90.3:8118";
              HTTPS_PROXY = "http://10.0.90.3:8118";
            };
            # 3. If you need a static IP, uncomment this:
            # networks.nsfw-network.ipv4_address = "10.0.90.10";
          };
        };
      };
    };
  };
}
