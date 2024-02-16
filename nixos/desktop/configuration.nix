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
      splashImage = /home/vavakado/wallpaper.png;
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
    jack.enable = true;
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
    alacritty # terminal
    anki # hebrew
    blueman # bluepoop
    btop # system monitor
    calibre # e-books
    clang # doom emacs depend
    cmake # libvterm for emacs
    coreutils # emacs
    docker-compose # bruh
    emacs-gtk # the goat
    eza # ls for zoomers
    fd # fast
    feh # wallpaper
    ffmpeg # av1 all the way
    flameshot # screeshit
    gh # someday i will host my own gitlab instance
    git # the best VCS
    gnumake # bruh
    graphviz # org-roam
    gvfs # something
    gzip # zip
    imagemagickBig # webp is so small
    imv # feh but better
    librewolf # the best browser
    libtool # vterm
    libvterm # vterm
    mpv # best music player
    neovim # for editing configs
    nil # nix lsp
    nixfmt # nix fmt
    ntfs3g # i still use windows(
    p7zip # 7z
    pavucontrol # audio
    picom # vsync
    polybarFull # the best X11 bar
    python3 # hate it
    qbittorrent # best torrent client
    rclone # i still use drop box
    ripgrep # zoomer grep
    rofi # app launcher
    rustup # r**t (i am not gay i swear)
    sccache # ccache but better
    signal-desktop # anon
    spotdl # i still use spotify
    spotify # premium((((
    starship # bash but beautiful
    sunshine # best remote desktop for linux
    tealdeer # no man, i use tldr
    telegram-desktop # friends
    thefuck # fuck
    tmux # best terminal multiplexer
    tor-browser # hehehe
    trash-cli # optional dependeecy of something
    unzip # dunno
    usbutils # lsusb
    vesktop # discord
    wget # curl is worse
    xfce.thunar # gui
    yuzu-early-access # switch
    zip # why
    zoxide # cd for zoomers
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
