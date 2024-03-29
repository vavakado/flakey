# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

let
  sunshineOverride = pkgs.sunshine.overrideAttrs (prev: {
    runtimeDependencies = prev.runtimeDependencies
      ++ [ pkgs.linuxKernel.packages.linux_zen.nvidia_x11 ];
  });
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./telegael.nix
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

  fileSystems."/mnt/steamlib" = {
    device = "/dev/disk/by-partuuid/8d7673f4-5d31-4aeb-9c27-ec00fe396db4";
    fsType = "ext4";
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
  # i still use windows(
  time.hardwareClockInLocalTime = true;

  # no more x11
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables.WLR_NO_HARDWARE_CURSORS = "1";
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
    extraGroups = [
      "wheel"
      "docker"
      "uinput"
      "fuse"
      "input"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
  };

  # dunno
  programs.dconf.enable = true;
  programs.gnupg = {
    agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-all;
    };
  };

  # i both love and hate nixos
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
    magicOrExtension = "\\x7fELF....AI\\x02";
  };

  # real vpn, not your privacy bs
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "856127940c59da11" ];
  };
  # PACKAGES
  environment.systemPackages = with pkgs; [
    anki
    blender # for godot
    blueman # bluepoop
    btop # system monitor
    calibre # e-books
    cava
    cinnamon.nemo
    clang # doom emacs depend
    cmake # libvterm for emacs
    coreutils # emacs
    docker-compose
    emacs29-pgtk # the goat
    eza # ls for zoomers
    fd # find for zoomers
    ffmpeg # av1 all the way
    fractal
    gamescope
    gdtoolkit
    gh # someday i will host my own gitlab instance
    git # the best VCS
    gnumake # bruh
    godot_4 # better than unity
    graphviz # org-roam
    grim
    gvfs # something
    gzip # zip
    imagemagickBig # webp is so small
    kitty
    librewolf # the best browser
    libtool # vterm
    libvterm # vterm
    localsend # airdrop but free as in freedom
    lutris
    mako
    mate.mate-polkit
    mpv # best music player
    neovim # for editing configs
    newsflash
    nil # nix lsp
    nixfmt # nix fmt
    nomacs
    ntfs3g # i still use windows(
    obs-studio
    p7zip # 7z
    pavucontrol # audio
    pkg-config
    polkit
    protonup-qt
    python3 # hate it
    qbittorrent # best torrent client
    rclone # i still use drop box
    ripgrep # zoomer grep
    rust-analyzer
    rustup # r**t (i am not gay i swear)
    sccache # ccache but better
    slurp
    soundconverter
    spotify # premium((((
    sqlite
    sqlite-interactive
    sunshineOverride
    swww
    tealdeer # no man, i use tldr
    telegram-desktop
    tmux # best terminal multiplexer
    usbutils # lsusb
    vesktop # discord
    waybar
    wget # curl is worse
    wl-clipboard
    wofi
    xdg-desktop-portal-wlr
    xfce.thunar # gui
    zip # why
  ];
  #security oooow
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  #locate
  services.locate.package = pkgs.plocate;
  services.locate.enable = true;
  services.locate.localuser = null;

  system.autoUpgrade = {
    enable = true;
    flake = "/home/vavakado/flakey";
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "weekly";
    randomizedDelaySec = "45min";
  };

  # so calibre can see my book
  services.udisks2.enable = true;

  # bluepoop
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # for sunshine
  networking.firewall.allowedTCPPorts =
    [ 8080 8096 53317 47984 47989 47990 48010 ];
  networking.firewall.allowedUDPPorts =
    [ 8080 8096 53317 47998 47999 47999 48000 ];

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  # i still can't decide between these three
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    twitter-color-emoji
    twemoji-color-font
    emojione
    (nerdfonts.override {
      fonts = [ "CascadiaCode" "VictorMono" "Iosevka" "JetBrainsMono" ];
    })
  ];

  # docker
  virtualisation.docker = {
    enableNvidia = true;
    enable = true;
    rootless.enable = true;
  };

  # Enable the sshd
  services.openssh.enable = true;

  system.stateVersion = "23.11"; # DO NOT CHANGE

}
