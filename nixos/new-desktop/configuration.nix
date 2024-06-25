# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, pkgs, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # GRUB stuff
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiInstallAsRemovable = true;
    efiSupport = true;
    useOSProber = true;
  };
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "b93f3baf";
  services.zfs.autoScrub.enable = true;
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
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  programs.nix-ld.enable = true;

  # the goat
  i18n.defaultLocale = "en_US.UTF-8";
  # i still use windows(
  time.hardwareClockInLocalTime = true;

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
    extraGroups = [ "wheel" "docker" "uinput" "fuse" "input" "libvirtd" ];
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
  # services.zerotierone = {
  #   enable = true;
  #   joinNetworks = [ "856127940c59da11" ];
  # };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/vavakado/flakey";
  };

  # PACKAGES
  environment.systemPackages = with pkgs; [
    # # feh
    # # flameshot
    # # handbrake
    # # inputs.nix-citizen.packages.${system}.lug-helper
    # # inputs.nix-citizen.packages.${system}.star-citizen-helper
    # # newsflash
    # # picom
    # # polybarFull
    # # rofi
    # # xclip
    # (sunshine.override { cudaSupport = true; })
	blueberry
    # btop # system monitor
    # clang-tools
    # dotnet
    ffmpeg # av1 all the way
    # filezilla
    # gamemode
    # gamescope
    # gcc
    # gnome.file-roller
    # gnumake # bruh
	lftp
    # greetd.tuigreet
    # grim
    # gvfs # something
    # gzip # zip
    # imagemagick # webp is so small
    # imv
    # inputs.nix-alien.packages.${system}.nix-alien
    # jellyfin-media-player
    # jellyfin-mpv-shim
    # jftui
    # kitty
    # librewolf # the best browser
    # lmms
    # localsend # airdrop but free as in freedom
    lutris
    # mangohud
    # mate.mate-polkit
    # mpv # best music player
    # nil # nix lsp
    # niri
    nix-index
    # nixfmt # nix fmt
    # nomacs
    # ntfs3g # i still use windows(
    # obs-studio
    # p7zip # 7z
    # pavucontrol # audio
    # pkg-config
    # polkit
    # prismlauncher
    protonup-qt
    # python3 # hate it
    # qbittorrent # best torrent client
    # rclone # i still use drop box
    # reaper
    # ripgrep # zoomer grep
    # rust-analyzer
    # rustup # r**t (i am not trans i swear)
    # soundconverter
    # swww
    # telegram-desktop
    # unzip
    # usbutils # lsusb
    # vesktop # discord
    # vkd3d-proton
    # waybar
    # wine
    # wine64
    # winetricks
    # xfce.thunar # gui
    # zip # why
    (blender.override { cudaSupport = true; }) # for godot
    alacritty
    astyle
    cinnamon.nemo-fileroller
    cinnamon.nemo-with-extensions
    clang
    docker-compose
    dotnet-runtime_8
    dotnet-sdk_8
    dwarfs
    firefox
    gh
    git
    godot_4 # better than unity
    libnotify
    mako
    mono
    ollama
    python3
    swaybg
    tmux # best terminal multiplexer
    unityhub
    vim
    waybar
    wget # curl is worse
    wofi
  ];

  programs.steam.enable = true;

  # disable dualshock touchpad
  services.udev.extraRules = ''
    # Disable DS4 touchpad acting as mouse
    # USB
    ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    # Bluetooth
    ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  #security oooow
  security.polkit.enable = true;
  programs.fuse.userAllowOther = true;

  # I wont use a proper DE
  services.greetd.enable = true;
  services.greetd.settings = {
    default_session = {
      command =
        "${pkgs.greetd.tuigreet}/bin/tuigreet -r --remember-session --cmd Hyprland";
      user = "vavakado";
    };
  };
  # services.xserver.libinput.mouse.accelSpeed = "0.0";
  # services.xserver.libinput.mouse.accelProfile = "flat";
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

  # #locate
  # services.locate.package = pkgs.plocate;
  # services.locate.enable = true;
  # services.locate.localuser = null;

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

  # services.tailscale = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # i still can't decide between these three
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    emojione
    (nerdfonts.override {
      fonts = [
        "CascadiaCode"
        "DaddyTimeMono"
        "VictorMono"
        "Iosevka"
        "Hasklig"
        "JetBrainsMono"
      ];
    })
  ];

  # Docker
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
