{ config, lib, pkgs, inputs, modulesPath, ... }: {
  services.qemuGuest.enable = true;

  ### Import Qemu Config
  # NOTE: This is not documented in the install guide
  #
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  ### Enable LISH and Linode Booting w/ GRUB
  #
  boot = {
    ### Add Required Kernel Modules
    # NOTE: These are not documented in the install guide
    #
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
      "ahci"
      "sd_mod"
    ];

    ### Set Up LISH Serial Connection
    #
    kernelParams = [ "console=ttyS0,19200n8" ];

    loader = {
      ### Increase Timeout to Allow LISH Connection
      # NOTE: The image generator tries to set a timeout of 0, so we must force
      #
      timeout = lib.mkForce 10;

      grub = {
        enable = true;
        version = 2;
        forceInstall = true;
        device = "nodev";

        # Allow serial connection for GRUB to be able to use LISH
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';

        ### Link /boot/grub2 to /boot/grub
        # NOTE: This is not documented in the install guide
        #
        extraInstallCommands = ''
          ln -s /boot/grub /boot/grub2
        '';
      };
    };
  };
}
