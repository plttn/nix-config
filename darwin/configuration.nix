{ inputs, outputs, lib, config, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ pkgs.vim ];

  # nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    hostPlatform = "aarch64-darwin";
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig =
    "$HOME/.config/nix-config/darwin/configuration.nix";

  environment.shells = [ pkgs.fish pkgs.zsh ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  nix.settings = {
    experimental-features = "nix-command flakes repl-flake";
    # brought in from DetSys
    build-users-group = "nixbld";
    bash-prompt-prefix = "(nix:$name)040";
    max-jobs = "auto";

    extra-nix-path = "nixpkgs=flake:nixpkgs";
    auto-optimise-store = true;
    trusted-users = [ "jack" ];
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;
  programs.fish.enable = true;

  programs.fish.loginShellInit = let
    # This naive quoting is good enough in this case. There shouldn't be any
    # double quotes in the input string, and it needs to be double quoted in case
    # it contains a space (which is unlikely!)
    dquote = str: ''"'' + str + ''"'';

    makeBinPathList = map (path: path + "/bin");
  in ''
    fish_add_path --move --prepend --path ${
      lib.concatMapStringsSep " " dquote
      (makeBinPathList config.environment.profiles)
    }
    set fish_user_paths $fish_user_paths
  '';

  programs.bash.enable = true;

  homebrew = {
    enable = true;
    casks = [ "wezterm" ];
  };

  users.users.jack = {
    name = "jack";
    home = "/Users/jack";
    shell = pkgs.unstable.fish;
  };

  security.pam.enableSudoTouchIdAuth = true;
  system.defaults = {
    dock = {
      magnification = true;
      largesize = 80;
    };
    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    NSGlobalDomain = { AppleInterfaceStyleSwitchesAutomatically = true; };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

}
