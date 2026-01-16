{ config, pkgs, ... }:

{
    users.users.plucky = {
        enable = true;
        createHome = true;
        description = "Plucky Puffin";
        expires = "2030-01-01";
        extraGroups = [
            "wheel"
            "networkmanager"
            "audio"
            "video"
        ];
        hashedPassword = "$6$ASMi1cF9jL1HgY/X$dnUd2rGPXGB77FGry8odE/gTXOD62dZDiwfnB2/YTpjasF4c9VRD/5YoQiFhflwO0yn.XmxOTueLQAmCFgMfc.";
        homeMode = "700";
        ignoreShellProgramCheck = true;
        isNormalUser = true;
        shell = pkgs.fish;
    };
}
