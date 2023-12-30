username := env_var('USER')
hostname := `hostname`

hm-switch:
    home-manager switch --flake .#{{username}}@{{hostname}}

hm-build: 
    home-manager build --flake .#{{username}}@{{hostname}}
darwin-switch:
    darwin-rebuild switch --flake .#{{hostname}}
darwin-build:
    darwin-rebuild switch --flake .#{{hostname}}

update-fix:
    sudo mv /etc/bashrc /etc/bashrc.before-darwin
    sudo mv /etc/zshrc /etc/zshrc.before-darwin