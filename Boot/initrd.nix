{
  boot.initrd = {
    verbose = true;
    availableKernelModules = [ "nvme" ];
  };
}
