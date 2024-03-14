{
  pkgs,
  lib,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    starship
  ];

  home-manager.users.${user}.programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$shlvl"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$hg_branch"
        "$docker_context"
        "$package"
        "$cmake"
        "$dart"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$golang"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$perl"
        "$php"
        "$purescript"
        "$python"
        "$ruby"
        "$rust"
        "$swift"
        "$terraform"
        "$vagrant"
        "$zig"
        "$nix_shell"
        "$conda"
        "$memory_usage"
        "$kubernetes"
        "$aws"
        "$gcloud"
        "$openstack"
        "$env_var"
        "$crystal"
        "$custom"
        "$cmd_duration"
        "$line_break"
        "$lua"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$character"
      ];
      add_newline = false;
      character = {
        success_symbol = "[└─>](bold green)";
        error_symbol = "[└─>](bold red) ";
      };
      package = {
        disabled = true;
      };
      cmd_duration = {
        min_time = 200;
      };
      php = {
        disabled = true;
      };
      nodejs = {
        disabled = true;
      };
      aws = {
        disabled = true;
      };
      kubernetes = {
        format = "at [$symbol$context( \($namespace\))]($style) ";
        disabled = false;
      };
    };
  };
}
