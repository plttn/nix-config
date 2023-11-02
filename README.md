# nix-config

## Home Manager

`home-manager --flake .#your-username@your-hostname`

## Nix-Darwin

`darwin-rebuild --flake .#hostname`

No inheritances between `nix-darwin` and `home-manager`, run one, run both, have fun
