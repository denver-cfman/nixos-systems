{ config, pkgs, lib, inputs, ... }:

let
  vncPassword = builtins.getEnv "VNC_PW";
  finalVncPw = if vncPassword != "" then vncPassword else "password";
  torbImageTag = builtins.getEnv "TORB_IMAGE_TAG";
  finalTorbImageTag = if torbImageTag != "" then torbImageTag else "aarch64-1.17.0-rolling-daily";
in
{
  virtualisation.arion = {
    # 1. Set this at the top level of the arion attribute
    backend = "podman-socket";

    projects.arion-container-stack = {
      settings = {
        # 2. Force the global network registry
        docker-compose.raw.networks.NSFW = {
          external = true;
        };

        services.nsfw-browser.service = {
          image = "kasmweb/tor-browser:" + finalTorbImageTag;
          networks = [ "NSFW" ];
          environment = {
            VNC_PW = finalVncPw;
            HTTP_PROXY = "http://10.0.90.3:8118";
            HTTPS_PROXY = "http://10.0.90.3:8118";
          };
        };
      };
    };
  };
}
