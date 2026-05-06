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
        out.dockerCompose.service = {
            shm_size = "512m";
        };
        services = {
          nsfw-browser = {
            service = {
              image = "kasmweb/tor-browser:" + finalTorbImageTag;
              ports = [ "6901:6901" ];
              environment = {
                VNC_PW = finalVncPw;
              };
            };
          };
        };
      };
    };
  };
}
