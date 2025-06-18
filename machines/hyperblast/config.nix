{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "hyperblastng"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  fileSystems."/var/lib/mpd/music/00_music" = {
    device = "//kgb.cbrp3.c-base.org/music";
    fsType = "cifs";
    options = [
      "ro"
      "username=mpeg"
      "password=blast"
      "uid=0"
      "gid=0"
      "dir_mode=0777"
      "file_mode=0666"
    ];
  };

  fileSystems."/var/lib/mpd/music/01_incoming" = {
    device = "//kgb.cbrp3.c-base.org/incoming/music";
    fsType = "cifs";
    options = [
      "ro"
      "username=mpeg"
      "password=blast"
      "uid=0"
      "gid=0"
      "dir_mode=0777"
      "file_mode=0666"
    ];
  };

  fileSystems."/var/lib/mpd/music/02_megablast" = {
    device = "//10.0.1.24/music";
    fsType = "cifs";
    options = [
      "ro"
      "username=alien"
      "password=alien"
      "sec=ntlmssp"
      "uid=0"
      "gid=0"
      "dir_mode=0777"
      "file_mode=0666"
    ];
  };

  fileSystems."/var/lib/mpd/music/04_mfs" = {
    device = "//mfs.cbrp3.c-base.org/mfs/Music";
    fsType = "cifs";
    options = [
      "ro"
      "username=guest"
      "password=guest"
      "uid=0"
      "gid=1"
      "dir_mode=0777"
      "file_mode=0666"
    ];
  };



  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    systemWide = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alien = {
    isNormalUser = true;
    description = "Alien";
    extraGroups = [
      "networkmanager"
      "wheel"
      "pipewire"
    ];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.neovim.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cifs-utils
    vim
    wget
    htop
    btop
    gnumake
    git
    bash
    python3
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
