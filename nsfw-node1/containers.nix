{ config, pkgs, ... }:

{
  virtualisation.arion = {
    backend = "docker"; # Or "podman-socket" if you're using podman
    
    projects.my-stack = {
      settings = {
        # This is where your "docker-compose" logic goes, but in Nix syntax
        services = {
          web-server = {
            service.image = "nginx:latest";
            service.ports = [ "8080:80" ];
            service.volumes = [
              "/var/lib/my-app/html:/usr/share/nginx/html"
            ];
          };
          
          database = {
            service.image = "postgres:15";
            service.environment.POSTGRES_PASSWORD = "password"; # Use sops-nix for real secrets!
          };
        };
      };
    };
  };
}
