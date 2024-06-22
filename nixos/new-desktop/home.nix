{ pkgs, lib, ... }: {
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

  # home.sessionVariables = { EDITOR = "nvim"; };
  # home.sessionPath = [ "$HOME/.cargo/bin" ];
  home.packages = with pkgs; [
    vesktop
    pavucontrol
    alsa-utils
    btop
    anki
    neovide
    nixfmt
    wl-clipboard
    telegram-desktop
    calibre
    gdu
    # deadnix
    go
    gimp
    gocryptfs
    gopls
    gotools
    nb
    # # qownnotes
    # marksman
    # # mitschemeX11
    keepassxc
    ripgrep
    # nodejs
    # prettierd
    ranger
    tig
    pandoc
    # nmap
    bat
    # w3m-nox
    glow
    dust
    statix
    viu
    fd
  ];
}
