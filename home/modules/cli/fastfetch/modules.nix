{ getColor }:
[
  {
    type = "title";
    color = {
      user = getColor "base0D";
      at = getColor "base03";
      host = getColor "base0D";
    };
  }

  {
    type = "custom";
    format = "";
  }

  {
    type = "os";
    key = "OS";
    keyIcon = "";
  }

  {
    type = "host";
    key = "Host";
    keyIcon = "";
  }

  {
    type = "kernel";
    key = "Kernel";
    keyIcon = "";
  }

  {
    type = "uptime";
    key = "Uptime";
    keyIcon = "";
  }

  {
    type = "packages";
    key = "Pkgs";
    keyIcon = "󰏗";
    format = "{all}";
  }

  {
    type = "shell";
    key = "Shell";
    keyIcon = "";
  }

  {
    type = "terminal";
    key = "Terminal";
    keyIcon = "";
  }

  {
    type = "terminalfont";
    key = "TermFont";
    keyIcon = "";
  }

  {
    type = "de";
    key = "DE";
    keyIcon = "";
  }

  {
    type = "wm";
    key = "WM";
    keyIcon = "";
  }

  {
    type = "wmtheme";
    key = "WMTheme";
    keyIcon = "";
  }

  {
    type = "theme";
    key = "Theme";
    keyIcon = "";
  }

  {
    type = "icons";
    key = "Icons";
    keyIcon = "";
  }

  {
    type = "display";
    key = "Display";
    keyIcon = "󰍹";
    compactType = "original-with-refresh-rate";
  }

  {
    type = "cpu";
    key = "CPU";
    keyIcon = "";
  }

  {
    type = "gpu";
    key = "GPU";
    keyIcon = "󰍛";
  }

  {
    type = "memory";
    key = "Memory";
    keyIcon = "";
    format = "{used} / {total} ({percentage})";
  }

  {
    type = "swap";
    key = "Swap";
    keyIcon = "";
    format = "{used} / {total} ({percentage})";
  }

  {
    type = "disk";
    key = "Disk";
    keyIcon = "";
    folders = "/";
    useAvailable = true;
    format = "{size-used} / {size-total} ({size-percentage})";
  }

  {
    type = "separator";
    string = "─";
    outputColor = getColor "base03";
  }
]
