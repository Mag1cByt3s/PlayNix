{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    netcat-gnu
    file
    gparted
    tree
    wget
    zip
    unzip
    unrar
    p7zip
    htop
    btop
    fastfetch
    lsb-release
    socat
    rlwrap
    thefuck
    dfc
    zsh
    openvpn
    macchanger
    soapui
    ghex
    jq
    ntp
    redis
    imagemagick
    strace
    clamav
    # xsser broken at the moment due to python nose
    #xsser
    lsd
    bat
    man
    less
    grc
    libvncserver
    lshw
    lshw-gui
    thunderbird-bin
    helvum
    #mission-center
    psmisc
    aha
    pciutils
    clinfo
    glxinfo
    vulkan-tools
    wayland-utils
    acpi
    inetutils
    libfaketime
    wireguard-tools
    wol
    e2fsprogs
    tldr
    sshpass
    python312Packages.pyhanko
  ];
}
