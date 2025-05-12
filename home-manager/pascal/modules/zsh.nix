{ config, lib, pkgs, ... }:
let
  # load the configuration that we was generated the first
  # time zsh were loaded with powerlevel enabled.
  # Make sure to comment this part (and the sourcing part below)
  # before you ran powerlevel for the first time or if you want to run
  # again 'p10k configure'. Then, copy the generated file as:
  # $ mv ~/.p10k.zsh p10k-config/p10k.zsh
  configThemeNormal = "p10k.zsh";
  configThemeTTY = "p10k-portable.zsh";
in
{
  fonts.fontconfig.enable = true;

    programs = {
          zsh = {
                ## See options: https://nix-community.github.io/home-manager/options.xhtml

                # enable zsh
                enable = true;

                # Enable zsh completion.
                enableCompletion = true;

                # Enable zsh autosuggestions
                autosuggestion.enable = true;

                # Enable zsh syntax highlighting.
                syntaxHighlighting.enable = true;

                # Commands that should be added to top of {file}.zshrc.
                initContent = lib.mkBefore ''
                  # The powerlevel theme I'm using is distgusting in TTY, let's default
                  # to something else
                  # See https://github.com/romkatv/powerlevel10k/issues/325
                  # Instead of sourcing this file you could also add another plugin as
                  # this, and it will automatically load the file for us
                  # (but this way it is not possible to conditionally load a file)
                  # {
                  #   name = "powerlevel10k-config";
                  #   src = lib.cleanSource ./p10k-config;
                  #   file = "p10k.zsh";
                  # }
                  if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
                    [[ ! -f ${configThemeNormal} ]] || source ${configThemeNormal}
                  else
                    [[ ! -f ${configThemeTTY} ]] || source ${configThemeTTY}
                  fi

                  # disable nomatch to fix weird compatility issues with bash
                  setopt +o nomatch
                '';

                plugins = [
                  {
                    # A prompt will appear the first time to configure it properly
                    # make sure to select MesloLGS NF as the font in Konsole
                    name = "powerlevel10k";
                    src = pkgs.zsh-powerlevel10k;
                    file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
                  }
                  {
                    name = "powerlevel10k-config";
                    src = ./p10k-config;
                    file = "${configThemeNormal}";
                  }
                ];

                oh-my-zsh = {
                    # enable oh-my-zsh
                    enable = true;

                    plugins = [
                        "git"
                        "docker"
                        "colorize"
                        "colored-man-pages"
                        "sudo"
                        "z"
                    ];

                };

                # define shell aliases which are substituted anywhere on a line
                # https://home-manager-options.extranix.com/?query=programs.zsh.shellGlobalAliases&release=master
                shellGlobalAliases = {
                    # general
                    ls = "lsd";
                    ll = "lsd -la";
                    la = "lsd -la";
                    lsa = "lsd -la";
                    tree = "lsd --tree -a";
                    cat = "bat";
                    pcat = "'cat'";
                    code = "codium";
                    vscode = "codium";
                    vscodium = "codium";
                    smbclient-ng ="smbclientng";
                    mono-csc = "csc";

                    # nixos
                    playnix-rebuild = "bash <(curl -L https://raw.githubusercontent.com/Mag1cByt3s/PlayNix/main/rebuild.sh)";

                    # shell aliases
                    python3-shell = ''
                      function _python3_shell {
                        local venv_dir=".venv"
                        python3 -m venv "$venv_dir" && \
                        source "$venv_dir/bin/activate"
                      }
                      _python3_shell
                    '';
                    python-shell = "python3-shell";
                    python2-shell = ''
                      function _python2_shell {
                        local venv_dir=".venv2"
                        # Remove the venv directory if it exists
                        [[ -d "$venv_dir" ]] && rm -rf "$venv_dir"
                        # Create a new Python 2 venv and activate it
                        python2 -m virtualenv "$venv_dir" && \
                        source "$venv_dir/bin/activate"
                      }
                      _python2_shell
                    '';
                    ruby-shell = "nix-shell -p ruby bundler";
                    node-shell = "nix-shell -p nodePackages_latest.nodejs";
                    c-shell = "nix-shell -p gcc gnumake cmake";
                    cpp-shell ="c-shell";
                    rust-shell = "nix-shell -p rustup --command 'rustup default stable; return'";
                    php-shell = "nix-shell -p php";
                    go-shell = "nix-shell -p go";

                    ## distrobox
                    #arch-box = "distrobox create -n arch -i archlinux:latest --additional-packages 'git nano' --init && distrobox enter archlinux"; # disabled for now due to issues
                    kali-box = "distrobox create -n kali -i docker.io/kalilinux/kali-rolling:latest --additional-packages 'git nano neofetch' --init && distrobox enter kali";
                    debian-box = "distrobox create -n debian -i debian:latest --additional-packages 'systemd libpam-systemd git nano neofetch' --init && distrobox enter debian";
                    ubuntu-box = "distrobox create -n ubuntu -i ubuntu:latest --additional-packages 'git nano neofetch' --init && distrobox enter ubuntu";
                    fedora-box = "distrobox create -n fedora -i fedora:latest --additional-packages 'git nano neofetch' --init && distrobox enter fedora";
                };

                # define session variables
                # https://home-manager-options.extranix.com/?query=programs.zsh.localVariables&release=master
                localVariables = {
                    LANG = "en_US.UTF-8";
                    EDITOR = "vim";
                    XDG_RUNTIME_DIR = "/run/user/$UID";
                };

      };
   };  
}
