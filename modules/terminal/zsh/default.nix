{ pkgs, user, ... }:

{
  imports = [
    ../starship
  ];

  programs.zsh.enable = true;
  
  home-manager.users.${user}.programs.zsh = {
    enable = true;

    shellAliases = {
      "O_o"= "echo o_O";
      "o_O"= "echo O_o";
      "ll" = "ls -hal";
      ".." = "cd ../";
      "..."= "cd ../../";
      "size"= "du -shc";
      "z"= "zoxide";

        ### docker
      "d"="docker";
      "dps"="docker ps";
      "dc"="docker compose";
      "dcu"="docker compose up -d";
      "dcd"="docker compose down";
      "dcdv"="docker compose down -v";
      "dce"="docker-compose exec";
      "dcr"="docker-compose run";
      "dcb"="docker compose build";
      "dclear"="docker kill $(docker ps -q)";
      "runcli"="dc run cli";

        ### Symfony Alias
      "console"="bin/console";
      "d-console"="dc exec php-fpm bin/console";

        ### K8s
      "k8x"="kubectx";
      "k8s"="kubectl";
      "k8sp"="k8s get pods";
      "k8si"="k8s get ingress";
      "k8sl"="k8s logs";
      "k8se"="k8s exec -it";
    };

    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-completions"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-apple-touchbar"

        "djui/alias-tips"
        "ChrisPenner/copy-pasta"
      ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "command-not-found"
        "docker"
        "pip"
        "sudo"
        "alias-finder"
        "colored-man-pages"
        "composer"
        "colorize"
        "cp"
        "kate"
        "systemd"
        "vscode"
        "iterm2"
        "osx"
        "helm"
        "kubectl"
        "docker"
        "docker-compose"
        "aws"
        "history-substring-search"
      ];
    };
  };
}