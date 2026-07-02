{
  networking.networkmanager.wifi = {
    backend = "iwd";
    macAddress = "random";
    powersave = false;
    scanRandMacAddress = true;
  };
}
