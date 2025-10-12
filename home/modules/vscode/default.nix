{
  config,
  hostInfos,
  lib,
  pkgs,
  trivnixLib,
  userInfos,
  ...
}:
let
  inherit (lib)
    flatten
    mapAttrsToList
    mkIf
    optionalAttrs
    optionals
    ;

  prefs = config.userPrefs;
  selfPath = trivnixLib.mkStorePath "";
in
{
  options.userPrefs.vscode = import ./options.nix { inherit (lib) mkEnableOption mkOption types; };
  config = mkIf prefs.vscode.enable {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
      package = mkIf prefs.vscode.useCodium pkgs.vscodium;
      profiles.default = {
        extensions = [
          pkgs.vscode-extensions.jnoortheen.nix-ide
          pkgs.vscode-extensions.arrterian.nix-env-selector
        ]
        ++ (flatten (
          mapAttrsToList (
            name: value: (map (package: pkgs.vscode-extensions.${name}.${package})) value
          ) prefs.vscode.otherExtensions
        ));

        userSettings = {
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;
          "explorer.confirmDelete" = false;
          "svelte.enable-ts-plugin" = true;
          "explorer.confirmDragAndDrop" = false;
          "terminal.integrated.stickyScroll.enabled" = false;
          "security.workspace.trust.untrustedFiles" = "open";
          "github.copilot.nextEditSuggestions.enabled" = true;
          "gitlens.ai.model" = "vscode";
          "gitlens.ai.vscode.model" = "copilot:gpt-4.1";
          "jdk.telemetry.enabled" = false;
          "java.import.gradle.server.launchMode" = "STANDARD";
        }
        // (optionalAttrs prefs.vscode.enableLsp {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.formatterPath" = "nixfmt";
          "nix.serverSettings".nixd = {
            formatting.command = [ "nixfmt" ];
            nixpkgs.expr = "import (builtins.getFlake \"${selfPath}\").inputs.nixpkgs { } ";
            options = {
              nixos.expr = "(builtins.getFlake \"${selfPath}\").nixosConfigurations.${hostInfos.name}.options";
              home-manager.expr = "(builtins.getFlake \"${selfPath}\").homeConfigurations.\"${userInfos.name}@${hostInfos.name}\".options";
            };
          };
        });
      };
    };

    home.packages = optionals prefs.vscode.enableLsp (
      builtins.attrValues {
        inherit (pkgs)
          nix-ld
          nixd
          nixfmt-rfc-style
          ;
      }
    );
  };
}
