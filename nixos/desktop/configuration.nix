# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # grub
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      useOSProber = true;
      device = "nodev";
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # my windows11(tm) drive
  fileSystems."/home/vavakado/heh" = {
    device = "/dev/disk/by-partuuid/2be7643d-46e7-96e2-d242-f873181ab5b4";
    fsType = "ntfs";
  };

  # gayming
  programs.steam.enable = true;

  networking.hostName = "nixpc"; # Define your hostname.

  # wifi has never been so easy
  networking.networkmanager.enable = true;

  # yes
  time.timeZone = "Asia/Jerusalem";

  # i am not a copyleft snob
  nixpkgs.config.allowUnfree = true;

  # nvidia
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
  };

  # the goat
  i18n.defaultLocale = "en_US.UTF-8";

  # i would love to use wayland but herbsluftwm is way too amazing
  services.xserver = {
    enable = true;
    windowManager.herbstluftwm.enable = true;
    displayManager.startx.enable = true;
    libinput.mouse.accelProfile = "flat";
    libinput.mouse.accelSpeed = "0.5";
    libinput.enable = true;
    wacom.enable = true;
    digimend.enable = true;
  };

  # Enable pipewire (pisswire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # i guess you've seen my username
  users.users.vavakado = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
  };

  # dunno
  programs.dconf.enable = true;
  programs.gnupg = {
    agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
  };

  # PACKAGES
  environment.systemPackages = with pkgs; [
    alacritty
    anki
    blueman
    btop
    calibre
    clang
    cmake
    conda
    coreutils
    docker-compose
    emacs-gtk
    eza
    fd
    feh
    ffmpeg
    flameshot
    gh
    git
    gnumake
    graphviz
    gvfs
    gzip
    htop
    imagemagickBig
    imv
    librewolf
    libtool
    libvterm
    micromamba
    mpv
    neovim
    nil
    nixfmt
    ntfs3g
    pavucontrol
    picom
    polybarFull
    python3
    qbittorrent
    rclone
    ripgrep
    rofi
    rustup
    sccache
    signal-desktop
    spotdl
    spotify
    starship
    sunshine
    tealdeer
    telegram-desktop
    tmux
    tor-browser # hehehe
    usbutils
    vesktop
    wget
    xfce.thunar
    xorg.xhost
    yuzu-early-access
    zoxide
  ];

  # docker
  virtualisation.docker = {
    enableNvidia = true;
    enable = true;
    rootless.enable = true;
  };

  # so calibre can see my book
  services.udisks2.enable = true;

  # bluepoop
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # for sunshine
  networking.firewall.allowedTCPPorts = [ 47984 47989 47990 48010 ];
  networking.firewall.allowedUDPPorts = [ 47998 47999 47999 48000 ];
  # this is awesome
  services.zerotierone.enable = true;

  # i still can't decide between these three
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [ "CascadiaCode" "VictorMono" "Iosevka" "JetBrainsMono" ];
    })
  ];

  # Enable the sshd
  services.openssh.enable = true;

  system.stateVersion = "23.11"; # DO NOT CHANGE

}
