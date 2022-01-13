{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  ### Set an initial password for root user
  #
  users.users.root.initialPassword = "Password1!";

  ### Set networking config
  #
  networking = {
    usePredictableInterfaceNames = false;
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
  };

  ### Install diagnostic tools for Linode support
  #
  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat
  ];

  ### Enable openssh for configuration
  #
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  system.stateVersion = "21.11";
}
