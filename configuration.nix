{ config, lib, pkgs, ... }:

let
  linux_x13s_pkg = { buildLinux, ... } @ args:
    buildLinux (args // rec {
      version = "6.3.5";
      modDirVersion = "6.3.5";

      src = pkgs.fetchurl {
        url = "https://github.com/steev/linux/archive/refs/heads/lenovo-x13s-linux-6.3.y.tar.gz";
        sha256 = "sha256-eBVysWw9ktMz7lR9pqqkgUqdHC0QgKC24tK/9INsPmo=";
      };
      kernelPatches = [];

      extraMeta.branch = "lenovo-x13s-linux-6.3.y";
    } // (args.argsOverride or { }));

  linux_x13s = pkgs.callPackage linux_x13s_pkg {
    defconfig = "laptop_defconfig";
  };

  linuxPackages_x13s = pkgs.linuxPackagesFor linux_x13s;
  dtbname = "sc8280xp-lenovo-thinkpad-x13s.dtb";
in {
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader.grub.enable = true;
    loader.grub.efiSupport = true;
    #loader.grub.efiInstallAsRemovable = true;
    loader.grub.device = "nodev";
    loader.grub.configurationLimit = 5; 
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot/efi";


    kernelPackages = linuxPackages_x13s;
    kernelParams = [
      "efi=noruntime"
      "clk_ignore_unused"
      "pd_ignore_unused"
      "root=PARTUUID=255a1f07-fa27-a641-b89f-ce4422318480"  
      #"dtb='${config.boot.kernelPackages.kernel}/dtbs/qcom/${dtbname}"
    ];
    initrd = {
      includeDefaultModules = false;
      availableKernelModules = [
        "nvme"
        "phy_qcom_qmp_pcie"
        "pcie_qcom"
        "i2c_hid_of"
        "i2c_qcom_geni"
        "leds_qcom_lpg"
        "pwm_bl"
        "qrtr"
        "pmic_glink_altmode"
        "gpio_sbu_mux"
        "phy_qcom_qmp_combo"
        "panel-edp"
        "msm"
        "phy_qcom_edp"
      ];
    };
  };
  hardware.firmware = [ (pkgs.callPackage ./x13s-firmware.nix{}) ]; 
  users.users.cenunix = {
    isNormalUser = true;
    initialPassword = "changeme";
    home = "/home/cenunix";
    extraGroups = [ "wheel" "networkManager"];
  };
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
  networking.hostName = "nixos-x13s";
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  environment.systemPackages = with pkgs; [
    libqrtr-glib
    (callPackage ./x13s-firmware.nix {})
    (callPackage ./qrtr.nix {})
    # (callPackage ./pd-mapper.nix {})
    neovim
    nano
    networkmanagerapplet
    git
    firefox
    armcord
    gh
    (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
    ];
    })
  ];

  system.stateVersion = "22.05";
}
