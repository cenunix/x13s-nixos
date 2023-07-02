Thinkpad X13s nixos-install 

Use mrObtains ubuntu iso https://drive.google.com/drive/folders/1wp1-X318MCI48xCAffJtyhDRvANkAE4q?usp=sharing

Connect to wifi, sudo apt update, and install the nix package manager using this command: sh <(curl -L https://nixos.org/nix/install) --daemon

You will need nixos-install-tools package, however you should first run sudo -i, then install it with nix: nix-env -iA nixpkgs.nixos-install-tools

Partition your drives, and mount them, root partition at /mnt and boot partition at /mnt/boot

nixos-generate-config command should generate a base config file for you at /mnt/etc/nixos

You should keep your hardware-configuration.nix as is but everything else should be replaced by the config files in this repo

nixos-install is the command to install nixos once your config files are set up, run this as root, so make sure you run sudo -i, then when you are logged in as root run nixos-install

YOU WILL NEED TO COPY THE DTB FILE INTO /mnt/boot! this is a crucial step for booting, and until i have a better solution that doesn't require this, make sure you do it, or you will have to boot back into the ubuntu iso and move it before booting, the machine will not boot without this step.

Reboot after the sc8280xp-lenovo-thinkpad-x13s.dtb file is in your /mnt/boot directory, and you have run nixos-install. It will take a while to build the kernel fyi, but you will not need to rebuild it unless you switch to a newer version from steev or a different commit hash. Feel free to check out my "nicks" repository for some other stuff until I have it all fully ported here for bluetooth etc. if you have problems open an issue please, I would love to make nixos a painless install on the x13s, using nixos configuration we can have some reproducibility for a unique machine which requires unique builds.
