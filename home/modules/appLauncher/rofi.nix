{
  config,
  ...
}:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      terminal = config.vars.terminalEmulator;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
      drun-display-format = "{name}";
    };

    theme = {
      "*".border-radius = mkLiteral "12px";
      mainbox.spacing = mkLiteral "12px";
      element-icon.size = mkLiteral "28px";

      window = {
        width = mkLiteral "720px";
        padding = mkLiteral "16px";
        border = mkLiteral "2px";
      };

      inputbar = {
        children = mkLiteral "[ prompt, entry ]";
        spacing = mkLiteral "8px";
        background-color = mkLiteral "transparent";
      };

      prompt = {
        enabled = true;
        padding = mkLiteral "8px 12px";
        border-radius = mkLiteral "10px";
      };

      entry = {
        padding = mkLiteral "8px 12px";
        expand = true;
        placeholder = "Search…";
        border-radius = mkLiteral "10px";
      };

      listview = {
        columns = 1;
        lines = 10;
        cycle = true;
        dynamic = true;
        scrollbar = true;
        fixed-height = false;
        padding = mkLiteral "4px 0px";
        background-color = mkLiteral "transparent";
      };

      element = {
        padding = mkLiteral "8px 10px";
        spacing = mkLiteral "10px";
        border-radius = mkLiteral "10px";
      };
    };
  };
}
