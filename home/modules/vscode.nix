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
        options = {
          nixos.expr = "(builtins.getFlake github:trivaris/trivnixConfigs).nixosConfigurations.${osConfig.hostInfos.configname}.options";
          home-manager.expr = "(builtins.getFlake github:trivaris/trivnixConfigs).nixosConfigurations.${osConfig.hostInfos.configname}.options.home-manager.users.type.getSubOptions []";
        };
      };
      "explorer.confirmDragAndDrop" = false;
      "workbench.secondarySideBar.defaultVisibility" = "hidden";
      "security.workspace.trust.untrustedFiles" = "open";
      "terminal.integrated.stickyScroll.enabled" = false;
      "terminal.integrated.initialHint" = false;
      "editor.stickyScroll.enabled" = false;
      "java.import.gradle.arguments" = [
        "--project-cache-dir"
        "/home/${osConfig.hostPrefs.mainUser}/.gradle-cache"
      ];
      "github.copilot.enable" = {
        "*" = false;
      };
    }
  );
in
{

  options.userPrefs.vscode.enable = lib.mkEnableOption "VSCode, a lightweight code editor";

  config = lib.mkIf vscodePrefs.enable {
    home.packages = [ pkgs.vscode ];
    home.activation.setupVSCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.config/Code/User"
      ${lib.getExe pkgs.jq} . ${rawSettings} > "/home/${config.userInfos.name}/.config/Code/User/settings.json"
    '';
  };

}
