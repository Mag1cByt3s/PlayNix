{ 
  config,
  lib,
  pkgs,
  modulesPath,
  ... 
}: {
  environment.persistence = {

    "/persist" = {
      hideMounts = true;

      files = [ 
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];

      directories = [
        # Essential system state
        "/root"
        "/etc/NetworkManager/system-connections"
        "/var/lib/NetworkManager"
        "/var/lib/systemd/coredump"
        "/var/lib/bluetooth"
        "/var/lib/fwupd"
        "/var/lib/upower"
        "/var/log"
        "/var/lib/nixos"
        "/etc/ssl/certs"

        # Package and app data
        "/var/lib/flatpak"
      ];
    };

  };
}
