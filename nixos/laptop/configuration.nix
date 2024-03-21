# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
    "ru_RU.KOI8-R/KOI8-R"
    "he_IL.UTF-8/UTF-8"
  ];

  specialisation = {
    on-power.configuration = {
      system.nixos.tags = [ "on-power" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;
        prime.sync.enable = lib.mkForce true;
      };
    };
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;

  services.zfs.autoScrub.enable = true;

  networking.hostId = "af5cffb5";
  # enable the best feature of nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # nice~
  networking.hostName = "nixuwu"; # Define your hostname.
  networking.networkmanager.enable = true;
  services.tlp = {
    enable = true;
    settings = { DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth"; };
  };
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  programs.steam.enable = true;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    enable = true;
    windowManager.herbstluftwm.enable = true;
    displayManager.startx.enable = true;
  };
  services.xserver.libinput.touchpad.naturalScrolling = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vavakado = {
    isNormalUser = true;
    description = "vavakado";
    extraGroups =
      [ "kvm" "networkmanager" "wheel" "docker" "libvirtd" "input" "uinput" ];
    packages = with pkgs; [ ];
    shell = pkgs.bash;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable gpg the proper way
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gtk2;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bat
    brightnessctl
    btop
    clang
    cmake
    coreutils
    dunst
    emacs # nice number(and editor)
    arandr
    fastfetch
    smartmontools
    fd
    feh
    ffmpeg-full
    flameshot
    fzf
    gh
    retroarchFull
    gimp
    git
    gnumake
    graphviz
    ifuse
    eza
    librewolf
    libtool
    libvterm
    localsend
    lshw
    moonlight-qt
    mpv
    ncdu
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nil
    nixfmt
    pavucontrol
    picom
    polybarFull
    python3
    qbittorrent
    rclone
    ripgrep
    rofi
    rustup
    spotdl
    spotify
    sqlite
    sqlite-interactive
    tealdeer
    telegram-desktop
    tor-browser
    vesktop
    wget
    xclip
    xfce.thunar
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  services.zerotierone.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
  services.locate.package = pkgs.mlocate;
  services.locate.enable = true;
  services.locate.localuser = null;
  services.openssh.enable = true;
  # some audio stuff
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];
  system.stateVersion = "23.11"; # Did you read the comment?

}
