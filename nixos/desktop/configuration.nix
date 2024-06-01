# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

let
  sunshineOverride = pkgs.sunshine.overrideAttrs (prev: {
    runtimeDependencies = prev.runtimeDependencies
      ++ [ pkgs.linuxKernel.packages.linux_zen.nvidia_x11 ];
  });
  # blenderOverride = pkgs.blender.overrideAttrs (prev: {
  #   runtimeDependencies = prev.runtimeDependencies
  #     ++ [ pkgs.linuxKernel.packages.linux_zen.nvidia_x11 ];
  #   cudaSupport = true;
  # });
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./telegael.nix
    # ./gpu-passthrough.nix
    #./nix-alien.nix
  ];
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.gvfs.enable = true;
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiInstallAsRemovable = true;
    efiSupport = true;
    useOSProber = true;
  };
services.xserver.windowManager.herbstluftwm.enable = true;
services.xserver.displayManager.startx.enable = true;
services.xserver.enable = true;
systemd.network.wait-online.enable = false;
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "b93f3baf";
  services.zfs.autoScrub.enable = true;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };
  networking.extraHosts = "127.0.0.1 modules-cdn.eac-prod.on.epicgames.com";

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
    # package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  programs.nix-ld.enable = true;

  # the goat
  i18n.defaultLocale = "en_US.UTF-8";
  # i still use windows(
  time.hardwareClockInLocalTime = true;

  # no more x11
  programs.hyprland.enable = false; #wait for may 15
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  #environment.variables.WLR_NO_HARDWARE_CURSORS = "1";
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
      "libvirtd"
    ]; # Enable ‘sudo’ for the user.
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

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/vavakado/flakey";
  };

  # PACKAGES
  environment.systemPackages = with pkgs; [
    #wofi #wayland
    anki
    unzip
    
    (blender.override { cudaSupport = true; }) # for godot
    
    blueman # bluepoop
    btop # system monitor
    cinnamon.nemo-fileroller
    cinnamon.nemo-with-extensions
    clang
    docker-compose
    dwarfs
    eza # ls for zoomers
    fd # find for zoomers
    feh
    ffmpeg # av1 all the way
    filezilla
    nix-index
    flameshot
    # fractal
    gamemode
    gamescope
    gdtoolkit
    gh # someday i will host my own gitlab instance
    git # the best VCS
    gnome.file-roller
    gnumake # bruh
    godot_4 # better than unity
    # graphviz # org-roam
    greetd.tuigreet
    # grim
    gvfs # something
    gzip # zip
    handbrake
    imagemagick # webp is so small
    # inputs.nix-citizen.packages.${system}.lug-helper
    # inputs.nix-citizen.packages.${system}.star-citizen-helper
    inputs.nix-alien.packages.${system}.nix-alien
    kitty
    librewolf # the best browser
    localsend # airdrop but free as in freedom
    lutris
    # mako
    mangohud
    mate.mate-polkit
    mpv # best music player
    newsflash
    nil # nix lsp
    nixfmt # nix fmt
    nomacs
    ntfs3g # i still use windows(
    obs-studio
    p7zip # 7z
    pavucontrol # audio
    picom
    pkg-config
    polkit
    polybarFull
    protonup-qt
    python3 # hate it
    qbittorrent # best torrent client
    rclone # i still use drop box
    ripgrep # zoomer grep
    rofi
    rust-analyzer
    rustup # r**t (i am not trans i swear)
    ollama
    # slurp
    soundconverter
    spotify # premium((((
    sqlite
    sqlite-interactive
    sunshineOverride
    # blenderOverride
    # swww
    tealdeer # no man, i use tldr
    telegram-desktop
    tmux # best terminal multiplexer
    usbutils # lsusb
    vesktop # discord
    vkd3d-proton
    # waybar
    wget # curl is worse
    wine
    wine64
    winetricks
    # wl-clipboard
    xclip
    # xdg-desktop-portal-wlr
    xfce.thunar # gui
    xorg.xhost
    zip # why
  ];
  #security oooow
  security.polkit.enable = true;
  programs.fuse.userAllowOther = true;
  services.greetd.enable = true;
  services.greetd.settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd startx";
      user = "vavakado";
    };
  };
     services.xserver.libinput.mouse.accelSpeed = "0.0";
services.xserver.libinput.mouse.accelProfile = "flat";
services.ollama = {
  enable = true;
  acceleration = "cuda";
};
  # i use the best mouse ever
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  hardware.uinput.enable = true;

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
    [ 8080 4950 4955 8096 53317 47984 47989 47990 48010 ];
  networking.firewall.allowedUDPPorts =
    [ 8080 4950 4955 8096 53317 47998 47999 47999 48000 ];

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
    liveRestore = false;
  };

  # Enable the sshd
  services.openssh.enable = true;
programs.ssh.startAgent = true;

  system.stateVersion = "23.11"; # DO NOT CHANGE

}
