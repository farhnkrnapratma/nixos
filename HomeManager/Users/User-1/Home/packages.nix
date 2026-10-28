{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # GUI
    decibels
    element-desktop
    gnome-calculator
    gnome-characters
    gnome-clocks
    iotas
    libreoffice
    loupe
    nautilus
    newsflash
    papers
    showtime
    # CLI
    codex
    file
    github-copilot-cli
    gnome-keyring
    just
    just-lsp
    shellcheck
    shfmt
    wl-clipboard
    # Misc
    cosmic-ext-applet-privacy-indicator
    libgnome-keyring
    yaru-theme
  ];
}
