{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ tdlib libwebp ];
}
