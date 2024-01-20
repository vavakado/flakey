# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  i18n.supportedLocales = [ "all" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # enable the best feature of nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # nice~
  networking.hostName = "nixuwu"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IL";

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  programs.steam.enable = true;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "he_IL.UTF-8";
    LC_IDENTIFICATION = "he_IL.UTF-8";
    LC_MEASUREMENT = "he_IL.UTF-8";
    LC_MONETARY = "he_IL.UTF-8";
    LC_NAME = "he_IL.UTF-8";
    LC_NUMERIC = "he_IL.UTF-8";
    LC_PAPER = "he_IL.UTF-8";
    LC_TELEPHONE = "he_IL.UTF-8";
    LC_TIME = "he_IL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;
    windowManager.herbstluftwm.enable = true;
    displayManager.startx.enable = true;
  };
  services.xserver.libinput.touchpad.naturalScrolling = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vavakado = {
    isNormalUser = true;
    description = "vavakado";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.wget
    pkgs.zoxide
    pkgs.lshw
    pkgs.kitty
    pkgs.polybarFull
    pkgs.rofi
    pkgs.librewolf
    pkgs.zellij
    pkgs.moonlight-qt
    pkgs.rclone
    pkgs.picom
    pkgs.feh
    pkgs.git
    pkgs.emacs-gtk # nice number(and editor)
    pkgs.ripgrep
    pkgs.coreutils
    pkgs.fd
    pkgs.clang
    pkgs.rustup
    pkgs.sqlite-interactive
    pkgs.sqlite
    pkgs.nil
    pkgs.brightnessctl
    pkgs.neovide
    pkgs.gh
    pkgs.graphviz
    pkgs.nixfmt
    pkgs.gnumake
    pkgs.cmake
    pkgs.libtool
    pkgs.libvterm
    pkgs.pavucontrol
    pkgs.tealdeer
    pkgs.vesktop
    pkgs.anki-bin
    pkgs.tor-browser
    pkgs.ifuse
    pkgs.qbittorrent
    pkgs.fastfetch
  ];

  virtualisation.docker.enable = true;
  programs.fish.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.locate.package = pkgs.mlocate;
  services.locate.enable = true;
  services.locate.localuser = null;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # some audio stuff
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.audio.enable = true;
  services.pipewire.wireplumber.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.jack.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
