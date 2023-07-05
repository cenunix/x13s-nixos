{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./services.nix
  ];

  #Feel free to change to desired username passwd etc.

  users.users.cenunix = {
    isNormalUser = true;
    initialPassword = "changeme";
    home = "/home/cenunix";
    extraGroups = ["wheel" "networkManager"];
  };

  networking.networkmanager.enable = true;
  networking.hostName = "nixos-x13s";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        qrtr = prev.callPackage ./qrtr.nix {};
        pd-mapper = final.callPackage ./pd-mapper.nix {inherit (final) qrtr;}; # i use a fork of pd-mapper because I changed the firmware path
        compressFirmwareXz = lib.id; #this leaves all firmware uncompressed :) for pd-mapper
      })
    ];
  };

  #GNOME for default DE, see in services.nix
  #The rest of these packages are just some essentials I like to have

  environment.systemPackages = with pkgs; [
    (callPackage ./pkgs/qrtr.nix {})
    (callPackage ./pkgs/pd-mapper.nix {}) #required for battery and sound, forked pd-mapper and changed path of firmware, leave firmware uncompressed using overlay.
    alsa-ucm-conf #>1.2.9 required for audio on x13s
    alsa-utils
    neovim
    networkmanagerapplet
    git
    firefox
    nheko
    webcord
    gh
    neofetch
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
      ];
    })
  ];

  system.stateVersion = "23.05";
}
