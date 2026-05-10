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
        docker-compose.raw.networks.nsfw-network = {
            name = "NSFW";
            external = true;
        };
        services.nsfw-browser = {
          # This 'service' block is where Docker-standard options go
          service = {
            image = "kasmweb/tor-browser:" + finalTorbImageTag;
            
            # 1. Define the network link HERE
            networks = [ "nsfw-network" ];
            
            environment = {
              VNC_PW = finalVncPw;
              HTTP_PROXY = "http://10.0.90.3:8118";
              HTTPS_PROXY = "http://10.0.90.3:8118";
            };
          };
        };
      };
    };
  };
}
