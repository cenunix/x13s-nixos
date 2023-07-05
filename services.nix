{
  config,
  lib,
  pkgs,
  ...
}: {
  #GNOME DE
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Bluetooth and audio stuffs

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
  #Services for x13s battery-sound etc. functionality, pd-mapper and qrtr relies on firmware

  systemd.services = {
    pd-mapper = {
      unitConfig = {
        Requires = "qrtr-ns.service";
        After = "qrtr-ns.service";
      };
      serviceConfig = {
        Restart = "always";
        ExecStart = "${pkgs.pd-mapper}/bin/pd-mapper";
      };
      wantedBy = [
        "multi-user.target"
      ];
    };
    qrtr-ns = {
      serviceConfig = {
        ExecStart = "${pkgs.qrtr}/bin/qrtr-ns -f 1";
        Restart = "always";
      };
      wantedBy = ["multi-user.target"];
    };
    #bluetooth systemd service thanks to steev and nixos docs, public addr needs to be set every boot
    bluetooth = {
      serviceConfig = {
        ExecStartPre = [
          ""
          "${pkgs.util-linux}/bin/rfkill block bluetooth"
          "${pkgs.bluez5-experimental}/bin/btmgmt public-addr F4:A8:0D:30:A3:47"
          "${pkgs.util-linux}/bin/rfkill unblock bluetooth"
        ];
        ExecStart = [
          ""
          "${pkgs.bluez}/libexec/bluetooth/bluetoothd -f /etc/bluetooth/main.conf --noplugin=sap"
        ];
      };
    };
  };
}
