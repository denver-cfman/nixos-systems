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
    projects.arion-container-stack.settings = {
      
      # 1. THE GLOBAL DECLARATION
      # This MUST be here to create the top-level 'networks' section.
      docker-compose.raw.networks = {
        NSFW = {
          external = true;
        };
      };

      # 2. THE SERVICE DEFINITION
      services.nsfw-browser.service = {
        image = "kasmweb/tor-browser:" + finalTorbImageTag;
        
        # Reference the network by the key used above
        networks = [ "NSFW" ];
        
        environment = {
          VNC_PW = finalVncPw;
          HTTP_PROXY = "http://10.0.90.3:8118";
          HTTPS_PROXY = "http://10.0.90.3:8118";
        };
      };
    };
  };
}
