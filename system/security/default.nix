{ config, ... }:

{
  security = {
    protectKernelImage = true;
    rtkit.enable = true;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      wheelNeedsPassword = false;
    };
  };
}
