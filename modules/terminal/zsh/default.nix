{ lib
, pkgs
, user
, ...
}:
let
  darwinSystem = pkgs.system == "x86_64-darwin";
in
{
  imports = [
    ../starship
  ];

  environment.systemPackages = with pkgs; [
    python3
    chroma
    du-dust
    eza
    btop
    tldr
  ];

  programs.zsh.enable = true;

  home-manager.users.${user} = {
    programs.zoxide.enable = true;
    programs.fzf.enable = true;
    programs.zsh = {
      enable = true;
      enableVteIntegration = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;

      antidote = {
        enable = false;
        useFriendlyNames = true;
        plugins =
          [
            "zsh-users/zsh-completions"
            "zsh-users/zsh-autosuggestions"
            "zsh-users/zsh-history-substring-search"
            "zsh-users/zsh-syntax-highlighting"

            "ChrisPenner/copy-pasta"
          ]
          ++ (lib.lists.optionals darwinSystem [
            "zsh-users/zsh-apple-touchbar"
          ]);
      };

      oh-my-zsh = {
        enable = true;
        plugins =
          [
            "git"
            "sudo"
            "alias-finder"
            "colored-man-pages"
            "colorize"
          ]
          ++ (lib.lists.optionals darwinSystem [
            "macos"
            "iterm2"
          ]);
      };

      shellAliases = {
        "O_o" = "echo o_O";
        "o_O" = "echo O_o";
        "ls" = "eza";
        "ll" = "ls -hal";
        ".." = "cd ../";
        "..." = "cd ../../";
        "size" = "dust";
        #        "z" = "zoxide";

        ### docker
        "d" = "docker";
        "dps" = "docker ps";
        "dc" = "docker compose";
        "dcu" = "docker compose up -d";
        "dcd" = "docker compose down";
        "dcdv" = "docker compose down -v";
        "dce" = "docker-compose exec";
        "dcr" = "docker-compose run";
        "dcb" = "docker compose build";
        "dclear" = "docker kill $(docker ps -q)";
        "runcli" = "dc run cli";

        ### Symfony Alias
        "d-console" = "dc exec php-fpm bin/console";

        ### K8s
        "k8x" = "kubectx";
        "k8s" = "kubectl";
        "k8sp" = "k8s get pods";
        "k8si" = "k8s get ingress";
        "k8sl" = "k8s logs";
        "k8se" = "k8s exec -it";

        "batt" = "${pkgs.acpi}/bin/acpi";
      };

      initExtraFirst = lib.strings.concatStringsSep "\n" (
        [
          # General
        ]
        ++ (
          if darwinSystem
          then [
            # Darwin spezific
          ]
          else [
            # Linux spezific
            "stty intr ^X" # interrupt commands with ctrl + x instead of c
          ]
        )
      );
    };
  };
}
