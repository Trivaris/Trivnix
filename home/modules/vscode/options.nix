{
  mkEnableOption,
  mkOption,
  types,
}:
{
  enable = mkEnableOption ''
    Enable VSCode 
  '';

  enableLsp = mkEnableOption ''
    Install nixd and configure Nix language tooling inside VSCodium.
    Enable when you want LSP support and formatter wiring for `.nix` files.
  '';

  useCodium = mkEnableOption ''
    Use Codium as instead of vscode.
    It is a privacy focused fork.
  '';

  otherExtensions = mkOption {
    type = types.attrsOf (types.listOf types.str);
    default = { };

    example = {
      svelte = [ "svelte-vscode" ];
      dbaeumer = [ "vscode-eslint" ];
    };

    description = ''
      Other Extensions you want to add to vscode.
    '';
  };
}
