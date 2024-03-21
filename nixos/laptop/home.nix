{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vavakado";
  home.homeDirectory = "/home/vavakado";

  qt.enable = true;
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;
  qt.platformTheme = "gtk";

  gtk.enable = true;
  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";
  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3-dark";
  gtk.iconTheme.package = pkgs.gruvbox-plus-icons;
  gtk.iconTheme.name = "GruvboxPlus";

  programs = {
    direnv = {enable = true; enableBashIntegration = true; nix-direnv.enable = true;};
    bash = {
      shellAliases = {
        v = "nvim";
	ls = "eza --icons=auto --color=auto";
	ll = "eza --icons=auto --color=auto -l";
	yeet = "sudo nixos-rebuild switch --flake /home/vavakado/flakey";
	".." = "cd ..";
      };
      enable = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.packages = [
    pkgs.mpc-cli
    pkgs.picard
  ];
  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
