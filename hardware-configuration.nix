{ config, lib, pkgs, inputs, modulesPath, ... }: {
  services.qemuGuest.enable = true;

  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  ### Enable LISH and Linode Booting w/ GRUB
  #
  boot = {
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
      "ahci"
      "sd_mod"
    ];
    kernelParams = [ "console=ttyS0,19200n8" ];

    loader = {
      timeout = lib.mkForce 10;

      grub = {
        enable = true;
        version = 2;
        forceInstall = true;
        device = "nodev";

        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';
      };
    };
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
