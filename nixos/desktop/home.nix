{ config, pkgs, lib, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vavakado";
  home.homeDirectory = "/home/vavakado";

  qt.enable = true;
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;
  qt.platformTheme.name = "adwaita";

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
      vimdiffAlias = true;
    };

    bash = {
      shellAliases = {
        v = "nvim";
        ls = "eza --icons=auto --color=auto";
        ll = "eza --icons=auto --color=auto -l";
        yeet = "~/rebuild";
        yaat = "home-manager switch --flake /home/vavakado/flakey";
        ".." = "cd ..";
        gs = "git status";
        gc = "git commit -a";
        g = "git";
      };
      bashrcExtra = "stty stop ''; stty start '';";
      enable = true; # see note on other shells below
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
    };

    home-manager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = { EDITOR = "nvim"; };
  home.sessionPath = [ "$HOME/.cargo/bin" ];
  home.packages = with pkgs; [
    calibre
    gdu
    deadnix
    go
    gimp
    gocryptfs
    gopls
    gotools
    nb
    qownnotes
    icu
    marksman
    mitschemeX11
    neovide
    keepassxc
    nodejs
    picard
    prettierd
    ranger
    tig
    pandoc
    nmap
    bat
    w3m-nox
    glow
    dust
    statix
    viu
  ];
}
