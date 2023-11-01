# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {

  home.file.sshAllowedSigners = {
    enable = true;
    source = ../conf.d/allowed_signers;
    target = ".ssh/allowed_signers";
  };
  programs.git = {
    enable = true;
    userName = "Jack Platten";
    userEmail = "jack@platten.me";
    # Replaces ~/.gitignore
    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "*.swp"
      "built-in-stubs.jar"
      "dumb.rdb"
      ".elixir_ls/"
      ".vscode/"
      "npm-debug.log"
      "shell.nix"
    ];


    # Replaces aliases in ~/.gitconfig
    aliases = {
      ba = "branch -a";
      bd = "branch -D";
      br = "branch";
      cam = "commit -am";
      co = "checkout";
      cob = "checkout -b";
      ci = "commit";
      cm = "commit -m";
      cp = "commit -p";
      d = "diff";
      dco = "commit -S --amend";
      s = "status";
      pr = "pull --rebase";
      st = "status";
      l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
      whoops = "reset --hard";
      wipe = "commit -s";
      fix = "rebase --exec 'git commit --amend --no-edit -S' -i origin/develop";
      # list aliases
      la = "!git config -l | grep alias | cut -c 7-";
    };
    extraConfig = {
      user = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGminsJAXUJkc7TH7qHU6RNdZuMcWIwdx+zZCDpDiUG";
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = "true";
      };
      commit = {
        gpgSign = true;
      };
      gpg = {
        format = "ssh";
        program = "${pkgs.gnupg}/bin/gpg";
        ssh =
          {
            allowedSignersFile = "~/.ssh/allowed_signers"; #don't love this but c'est la vie
          };
      };
    };
  };
}
