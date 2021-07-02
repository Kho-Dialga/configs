# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader and kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "sysrq_always_enabled=1" ];
    boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
      };
    systemd-boot = {
    enable = true;
    memtest86.enable = true;
    configurationLimit = 10;
    };
    #grub = {
    #version = 2;
    #efiSupport = true;
    #device = "nodev";
    #enable = true;
    #useOSProber = true;
    #};
  };

  # Disk optimization

  nix.autoOptimiseStore = true;

  # Set your time zone.
   time.timeZone = "America/Costa_Rica";

  # Networking
  networking.hostName = "cirnos"; # Define your hostname.
  networking.interfaces.enp6s0.useDHCP = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Add zsh
  programs.zsh = {
  enable = true;
  histFile = "$HOME/.cache/zsh/history";
  histSize = 2000;
  enableCompletion = true;
  autosuggestions.enable = true;
  };

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
   };

  # Configuring Xorg
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.libinput = {
	enable = false;
	mouse = {
		accelProfile = "flat";
	};
 };
  services.xserver.wacom.enable = true;
  services.xserver.windowManager = {
    dwm.enable = true;
    qtile.enable = true;
    xmonad.enable = true;
    awesome.enable = true;
    xmonad.enableContribAndExtras = true;
    xmonad.extraPackages = hpkgs: [
      hpkgs.xmonad
      hpkgs.xmonad-contrib
      hpkgs.xmonad-extras
    ];
  };
  # Configure keymap in X11
   services.xserver.layout = "us";

  # Enable CUPS to print documents.
   services.printing.enable = true;

  # Enable sane to scan documents
   hardware.sane.enable = true;

  # Enable udisks for easier USB mounting
   services.udisks2.enable = true;

  # Enable steam
   programs.steam.enable = true;

  # Enable neovim and the emacs
   programs.neovim.enable = true;
   services.emacs.enable = true;

  # OpenRGB udev
    services.udev.packages = with pkgs; [
    openrgb
  ];
  
  # ratbag
	services.ratbagd.enable = false;
  
  # Enable libvirt
	virtualisation.libvirtd.enable = true;
	programs.dconf.enable = true;
  
  # Enable pam_gnupg
	security.pam.services.login.gnupg.enable = true;
	security.pam.services.login.gnupg.storeOnly = true;

  # Enable opentabletdriver
	hardware.opentabletdriver.enable = true;
  # Enable droidcam
	programs.droidcam.enable = true;
    # Enable cron service
  services.cron = {
    enable = true;
	systemCronJobs = [
		"*/15 * * * * dialga export DISPLAY=:0; export XAUTHORITY=/run/user/1000/Xauthority; ~/.local/bin/cron/newsup"
		"*/15 * * * * dialga export DISPLAY=:0; export XAUTHORITY=/run/user/1000/Xauthority; ${pkgs.mutt-wizard}/bin/mailsync; ~/.local/bin/statusbar/refblock mailbox 12"
	];
  };

  # Fonts
  fonts.fonts = with pkgs; [
  twitter-color-emoji
  noto-fonts-cjk
  noto-fonts-emoji
  noto-fonts
  corefonts
  libertine
  symbola
  fira-code
  (nerdfonts.override { fonts = [ "FiraCode" ]; })
];

  # Enable sound.
    sound.enable = false;   
	#hardware.pulseaudio.enable = true;
  # Pipewire
	security.rtkit.enable = true;
	services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
};

  # Users
   users.users.dialga = {
     isNormalUser = true;
     shell = pkgs.zsh;
     extraGroups = [ "wheel" "audio" "video" "lpadmin" "scanner" "storage" "libvirtd" ];
   };

  # Enable unfree software, RMS doesn't approve of this...
   nixpkgs.config.allowUnfree = true;

  # Commands that dont need sudo when running them
  security.sudo.extraRules = [
    { groups = [ 1 ];
    commands = [ { command = "/run/current-system/sw/bin/nix-env -u"; options = [ "NOPASSWD" ]; }
    { command = "/run/current-system/sw/bin/nixos-rebuild switch"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/nixos-rebuild switch --show-trace"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/nixos-rebuild switch --upgrade"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/nixos-rebuild switch --upgrade --show-trace"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/nix-channel --update"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/nixos-rebuild test"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/nixos-rebuild test --show-trace"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/nix-channel --update"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/nix-collect-garbage"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/nix-collect-garbage -d"; options = ["NOPASSWD"]; }
	{ command = "/run/current-system/sw/bin/nvim -u ~/.config/nvim/init.vim /etc/nixos/configuration.nix"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/poweroff"; options = ["NOPASSWD"]; }
    { command = "/run/current-system/sw/bin/reboot"; options = ["NOPASSWD"]; } ]; }
  ];
  # Overlay for patched dwm and picom
  nixpkgs.overlays = [
    (self: super: {
    dwm = super.dwm.overrideAttrs (oldAttrs: rec {
    patches = [ ./dwm-dialga-6.2.patch ];
    });
    })
	(self: super: {
	picom = super.picom.overrideAttrs (old: {
		src = super.fetchFromGitHub {
		owner = "jonaburg";
		repo = "picom";
		rev = "d08c9b8c493d24c9df77f46147f4839849873a83";
		sha256 = "114y3y4651aihcj6impszk3rp9ljpfh2af3w1m4ffbd4c3ydgnhf";
		};
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
     ungoogled-chromium
     sxhkd
     dunst
     libnotify
     lf
     sxiv
     xwallpaper
     pamixer
     pulsemixer
     maim
     zsh
     zsh-completions
     nix-zsh-completions
     zsh-fast-syntax-highlighting
     zsh-autosuggestions
     zsh-history-substring-search
     psmisc
     xmobar
     linuxHeaders
     xclip
     bc
     wmctrl
     # useful
	 virt-manager
	 patchage
	 libva1
     alacritty
	 libvdpau-va-gl
	 file
	 pciutils
	 picom
	 ueberzug
	 imagemagick
     brave
     slock
     lm_sensors
     git
     gnome3.simple-scan
     mpd
     mpc_cli
     ncmpcpp
     mpv
     dragon-drop
     ffmpeg
     newsboat
     neomutt
     isync
     msmtp
     mutt-wizard
     notmuch
	 lynx
     pinentry
     pinentry-gnome
     pass
     ntfs3g
     unrar
     unzip
     mediainfo
     zathura
     poppler
     atool
     highlight
     xob
     trash-cli
     spaceship-prompt
     redshift
     transmission
     tremc
     xcb-util-cursor
     youtube-dl
     flat-remix-gtk
     flat-remix-icon-theme
	 xorg.xdpyinfo
     # others
     discord
     neofetch
     openrgb
     piper
     steam-run
     proton-caller
     wineWowPackages.stable
     groff
	 libreoffice
	 xournal
	 obs-studio
   ];

   # OpenGL
   hardware.opengl.driSupport = true;
   hardware.opengl.driSupport32Bit = true;
   hardware.opengl.setLdLibraryPath = true;
   hardware.opengl.extraPackages = with pkgs; [
	   mesa
	   vaapiVdpau
	   libva1
	   libvdpau-va-gl
   ];

# For 32 bit applications
# Only available on unstable
hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [
  amdvlk
  mesa
  pipewire
];
  # Some programs need SUID wrappers, can be configured further or are
  # tarted in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     pinentryFlavor = "gnome3";
     enableSSHSupport = true;
   };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?
}
