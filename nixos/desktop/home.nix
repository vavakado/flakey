{ pkgs, lib, inputs, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vavakado";
  home.homeDirectory = "/home/vavakado";

  qt.enable = true;
  qt.style.name = "lightly-dark";
  qt.style.package = pkgs.lightly-qt;
  # qt.platformTheme.name = "adwaita";

  gtk.enable = true;
  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Classic";
  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3-dark";
  gtk.iconTheme.package = pkgs.gnome.adwaita-icon-theme;
  gtk.iconTheme.name = "Adwaita";

  home.stateVersion = "23.11"; # don't change it bro

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    neovim = {
      enable = true;
      extraWrapperArgs = [
        "--suffix"
        "LIBRARY_PATH"
        ":"
        "${lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
        "--suffix"
        "PKG_CONFIG_PATH"
        ":"
        "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
          pkgs.stdenv.cc.cc
          pkgs.zlib
        ]}"
      ];
    };

    bash = {
      shellAliases = {
        ".." = "cd ..";
        v = "nvim";
      };
      enable = true; # see note on other shells below
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
    eza = {
      enable = true;
      icons = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
    };

    home-manager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = { EDITOR = "nvim"; };
  # home.sessionPath = [ "$HOME/.cargo/bin" ];
  home.packages = with pkgs; [
    grim
    imv
    mpv
    patchelf
    slurp
    stylua
    udiskie
    nomacs
    lua51Packages.lua
    lua51Packages.luarocks
    unzip
    # # mitschemeX11
    # # qownnotes
    # deadnix
    # marksman
    # nmap
    # nodejs
    # prettierd
    # w3m-nox
    #calibre
    #gimp
    #gocryptfs
    alsa-utils
    anki
    bat
    btop
    dust
    fd
    gdu
    glow
    go
    gopls
    gotools
    keepassxc
    nb
    neovide
    nixfmt
    pandoc
    pavucontrol
    ranger
    ripgrep
    gnumake
    spotify # premium((((
    statix
    tealdeer # no man, i use tldr
    telegram-desktop
    tig
    vesktop
    csharp-ls
    viu
    wl-clipboard
  ];
}
