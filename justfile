username := env_var('USER')
hostname := `hostname`

hm-switch:
    home-manager switch --flake .#{{username}}@{{hostname}}

hm-build: 
    home-manager build --flake .#{{username}}@{{hostname}}