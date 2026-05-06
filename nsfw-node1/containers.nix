{ config, pkgs, inputs, ... }:

{
  virtualisation.arion = {
    backend = "podman-socket";
    
    projects.my-stack = {
      settings = inputs.arion.lib.build {
        dockerComposeYaml = inputs.browser-stack-yaml;
      };
      #settings = {
      #  services = {
      #    web-server = {
      #      service.image = "mendhak/http-https-echo:latest";
      #      service.ports = [ "8080:8080" "8443:8443" ];
      #    };
      #  };
      #};
    };
  };
}
