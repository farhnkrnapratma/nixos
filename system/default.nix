{ config, ... }:

{
    imports = [
        ./boot
        ./console
        ./docs
        ./env
        ./fonts
        ./hardware
        ./i18n
        ./networking
        ./nix
        ./nixpkgs
        ./programs
        ./security
        ./services
        ./system
        ./time
        ./users
        ./zram
    ];
}
