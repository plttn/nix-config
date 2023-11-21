{
  config,
  pkgs,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
    pkgs.alejandra
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nix-config/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  nix.settings = {
    experimental-features = "nix-command flakes repl-flake";
    # brought in from DetSys
    build-users-group = "nixbld";
    bash-prompt-prefix = "(nix:$name)\040";
    max-jobs = "auto";
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    auto-optimise-store = true;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;
  programs.fish.enable = true;

  programs.bash.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  homebrew = {
    enable = true;
    casks = ["wezterm"];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
