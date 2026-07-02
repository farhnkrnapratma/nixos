{
  security.sudo-rs = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = true;
    extraConfig = ''
      Defaults pwfeedback
      Defaults timestamp_timeout=25
    '';
  };
}
