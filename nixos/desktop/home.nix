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
  gtk.cursorTheme.name = "Bibata-Modern-Classic";
  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3-dark";
  gtk.iconTheme.package = pkgs.gnome.adwaita-icon-theme;
  gtk.iconTheme.name = "Adwaita";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  services.mpd = {
    enable = true;
    musicDirectory = "/home/vavakado/Music";
    extraConfig = ''
      audio_output {
              type            "pipewire"
              name            "PipeWire Sound Server"
      }
    '';
  };
  programs.ncmpcpp.enable = true;
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    bash = {
      shellAliases = {
        v = "nvim";
        ls = "eza --icons=auto --color=auto";
        ll = "eza --icons=auto --color=auto -l";
        yeet = "sudo nixos-rebuild switch --flake /home/vavakado/flakey";
        ".." = "cd ..";
      };
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
  };
  home.sessionPath = [ "$HOME/.cargo/bin" "$HOME/.config/emacs/bin/" ];
  home.packages = with pkgs; [ mpc-cli ranger mpd-sima picard ];

  #home.sessionVariables = { EDITOR = "emacs -nw"; };
  programs.home-manager.enable = true;
}
