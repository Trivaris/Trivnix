{ mkEnableOption }:
{
  enableLsp = mkEnableOption ''
    Install nixd and configure Nix language tooling inside VSCodium.
    Enable when you want LSP support and formatter wiring for `.nix` files.
  '';

  fixServer = mkEnableOption ''
    Patch the VSCodium remote server to use the packaged Node.js binary.
    Helpful when remote sessions fail to start due to missing node runtimes.
  '';
}
