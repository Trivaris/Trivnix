{ ... }:
{
  programs.bash.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
      stdlib = ''
      : "''${XDG_CACHE_HOME:=$HOME/.cache}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash_path
          hash_path=$(echo -n "$PWD" | sha256sum | cut -d ' ' -f 1)
          echo "''${direnv_layout_dirs[$PWD]:=$XDG_CACHE_HOME/direnv/layouts/$hash_path}"
      }
    '';
  };
}
