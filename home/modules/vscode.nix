{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  vscodePrefs = config.userPrefs.vscode;
  rawSettings = pkgs.writeText "settings.json" (
    builtins.toJSON {
      "files.autoSave" = "afterDelay";
      "explorer.confirmDelete" = false;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${lib.getExe pkgs.nixd}";
      "nix.serverSettings".nixd = {
        formatting.command = [ "${lib.getExe pkgs.nixfmt}" ];
        options.nixos.expr = "(builtins.getFlake github:trivaris/trivnixConfigs).nixosConfigurations.${osConfig.hostInfos.configname}.options";
      };
      "explorer.confirmDragAndDrop" = false;
      "workbench.secondarySideBar.defaultVisibility" = "hidden";
      "security.workspace.trust.untrustedFiles" = "open";
      "terminal.integrated.stickyScroll.enabled" = false;
      "terminal.integrated.initialHint" = false;
      "editor.stickyScroll.enabled" = false;
    }
  );
in
{

  options.userPrefs.vscode.enable = lib.mkEnableOption "VSCode, a lightweight code editor";

  config = lib.mkIf vscodePrefs.enable {
    home.packages = [ pkgs.vscode ];
    home.file.".config/Code/User/settings.json".source = pkgs.runCommand "settings.json" {
      nativeBuildInputs = [ pkgs.jq ];
    } "jq . ${rawSettings} > $out";
  };

}
