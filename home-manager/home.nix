# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
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
    ffmpeg
    vivid
    # unstable.atuin # double specified so overlay kicks in
    # gnupg
    direnv
  ];


  home.sessionVariables = {
    # EDITOR = "emacs";
    fish_greeting = "";
  };

  xdg = {
    enable = true;
    configFile."fish/completions/nix.fish".source = "${pkgs.nix}/share/fish/vendor_completions.d/nix.fish";
    configFile."wezterm/wezterm.lua".source = ../conf.d/wezterm.lua;
  };


  programs.zoxide.enable = true;


  programs.fish = {
    enable = true;
    interactiveShellInit = "export LS_COLORS=\"$(vivid generate molokai)\"\n set --export fish_color_autosuggestion 555";
    shellInit = "eval \"$(/opt/homebrew/bin/brew shellenv)\"";

  };

  # programs.wezterm = {
  #   enable = true;
  #   package = null;
  #   extraConfig =
  #     "-- Pull in the wezterm API
  #     local wezterm = require 'wezterm'

  #     -- This table will hold the configuration.
  #     local config = {}

  #     -- In newer versions of wezterm, use the config_builder which will
  #     -- help provide clearer error messages
  #     if wezterm.config_builder then
  #       config = wezterm.config_builder()
  #     end

  #     -- This is where you actually apply your config choices

  #     -- For example, changing the color scheme:
  #     config.color_scheme = 'Brogrammer'

  #     config.font = wezterm.font('Berkeley Mono')
  #     config.harfbuzz_features = {'ss02'}
  #     config.font_size = 13
  #     config.hide_tab_bar_if_only_one_tab = true
  #     config.initial_cols = 110
  #     config.initial_rows = 30
  #     front_end = 'WebGpu'
  #     config.default_cursor_style = 'SteadyBar'
  #     config.hide_mouse_cursor_when_typing = true
  #     config.visual_bell = {
  #       fade_in_function = 'EaseIn',
  #       fade_in_duration_ms = 150,
  #       fade_out_function = 'EaseOut',
  #       fade_out_duration_ms = 150,
  #     }
  #     config.colors = {
  #       visual_bell = '#202020',
  #     }
  #     -- and finally, return the configuration to wezterm
  #     return config
  #     ";
  # };

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
      enter_accept = true;
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
