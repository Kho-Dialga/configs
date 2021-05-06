# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
      };
    grub = {
    efiSupport = true;
    device = "nodev";
    };
  };

   networking.hostName = "cirnos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
   time.timeZone = "America/Costa_Rica";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.interfaces.enp1s0.useDHCP = true;
  

  # Add shells
  programs.zsh.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  #services.xserver.displayManager.lightdm.enable = false;
  services.xserver.windowManager = {
    qtile.enable = true;
    dwm.enable = true;
  };
  # Configure keymap in X11
   services.xserver.layout = "us";

  # Enable CUPS to print documents.
   services.printing.enable = true;

  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.dialga = {
     isNormalUser = true;
     shell = pkgs.zsh;
     extraGroups = [ "wheel" "audio" "video" "lpadmin" "scanner" ];
   };

  # Enable unfree software, RMS doesn't approve of this...
   nixpkgs.config.allowUnfree = true;
  
  # Patched dwm build
  nixpkgs.overlays = [
    (self: super: {
    dwm = super.dwm.overrideAttrs (oldAttrs: rec {
    patches = [ ./dwm-dialga-6.2.patch ];
    });
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     # suckless utils
     (st.overrideAttrs (oldAttrs: rec {
     buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
     patches = [ ./st-dialga-0.8.4.patch ];
     })
     )
     (dmenu.overrideAttrs (oldAttrs: rec {
     patches = [ ./dmenu-dialga-5.0.patch ];
     })
     )
     (dwmblocks.overrideAttrs (oldAttrs: rec {
     patches = [ ./dwmblocks-dialga.patch ];
     })
     )
     # essentials
     neovim
     ungoogled-chromium
     sxhkd
     alacritty
     dunst
     lf
     sxiv
     xwallpaper
     pamixer
     pulsemixer
     maim
     fira-code
     noto-fonts
     noto-fonts-cjk
     zsh
     zsh-completions
     nix-zsh-completions
     zsh-fast-syntax-highlighting
     zsh-autosuggestions
     zsh-history-substring-search
     psmisc
     # useful
     lm_sensors
     git
     droidcam
     gnome3.simple-scan
     mpd
     mpc_cli
     ncmpcpp
     dragon-drop
     picom
     ffmpeg
     newsboat
     neomutt
     isync
     msmtp
     ntfs3g
     unrar
     unzip
     mediainfo
     zathura
     poppler
     atool
     fzf
     highlight
     xob
     trash-cli
     spaceship-prompt
     redshift
     transmission
     tremc
     xf86_input_wacom
     # others
     discord
     flat-remix-gtk
     flat-remix-icon-theme
     twitter-color-emoji
     neofetch
     osu-lazer
     wineStaging
     steam
     opentabletdriver
   ];
   
   # GPU acceleration
   hardware.opengl.driSupport = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?

}

