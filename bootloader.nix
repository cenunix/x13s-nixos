{ config
, lib
, pkgs
, ...
}:
{
  boot = {
    loader.grub.enable = true;
    loader.grub.efiSupport = true;
    loader.grub.efiInstallAsRemovable = true;
    loader.grub.device = "nodev";
    loader.grub.configurationLimit = 20;
    #loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot";

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "efi=noruntime"
      "clk_ignore_unused"
      "pd_ignore_unused"
      "arm64.nopauth"
      # "iommu.passthrough=0"
      # "iommu.strict=0"
      "pcie_aspm.policy=powersupersave"
    ];
    initrd = {
      includeDefaultModules = false;
      availableKernelModules = [
        "nvme"
        "phy_qcom_qmp_pcie"
        # "pcie_qcom"
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
  hardware.enableAllFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware (pkgs.callPackage ./pkgs/x13s-firmware.nix { }) ];
}
