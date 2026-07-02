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
    libreoffice-fresh
    loupe
    nautilus
    newsflash
    papers
    showtime
    # CLI
    codeberg-cli
    codex
    file
    gemini-cli
    github-copilot-cli
    glab
    gnome-keyring
    just
    just-lsp
    qwen-code
    shellcheck
    shfmt
    tea
    wl-clipboard
    # Misc
    cosmic-ext-applet-privacy-indicator
    libgnome-keyring
    yaru-theme
  ];
}
