# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./git.nix
  ];
  # colorScheme = inputs.nix-colors.colorSchemes.primer-dark;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # inputs.atuin-upstream.overlays.default
      # outputs.overlays.modifications.atuin

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "jack";
    homeDirectory = "/Users/jack";
  };

  xdg = {
    enable = true;
    configFile."fish/completions/nix.fish".source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";
    configFile."wezterm/wezterm.lua".source = ../conf.d/wezterm.lua;
    configFile."ov/config.yaml".source = ../conf.d/ov.yaml;
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  home.packages = with pkgs; [
    doggo
    bat
    nixpkgs-fmt
    asciinema
    gh
    nil
    nano
    nixpkgs-fmt
    unstable.eza
    just
    openssh
    rustup
    fzf
    fish
    _1password
    ngrok
    dnscontrol
    unstable.ov
    unstable.less
    ffmpeg
    vivid
    ripgrep
    # unstable.atuin # double specified so overlay kicks in
    # gnupg
    direnv
    (nerdfonts.override {fonts = ["Meslo" "Hermit"];})
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
    fish_greeting = "";
    PAGER = "less";
  };

  home.sessionPath = ["$HOME/.bin"];

  fonts.fontconfig.enable = true;

  programs.zoxide.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = "export LS_COLORS=\"$(vivid generate molokai)\"\n set --export fish_color_autosuggestion 555";
    shellInit = "eval \"$(/opt/homebrew/bin/brew shellenv)\"";
    functions = {
      dvd = "nix flake init --template github:the-nix-way/dev-templates#$argv[1]\n direnv allow";
    };
  };

  programs.atuin = {
    enable = true;
    package = pkgs.unstable.atuin;
    enableFishIntegration = true;
    settings = {
      filter_mode_shell_up_key_binding = "session";
      filter_mode = "host";
      show_preview = true;
      workspaces = true;
      # control_n_shortcuts = true;
      # enter_accept = true;
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      aliases = {
        co = "pr checkout";
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = "Host * \n IdentityAgent \"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  nix.package = pkgs.nix;
  nix.settings = {
    auto-optimise-store = true;
  };

  programs.man.generateCaches = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
