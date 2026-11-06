[
  {
    type = "os";
    key = "OS";
    keyIcon = "";
  }
  {
    type = "uptime";
    key = "Uptime";
    keyIcon = "";
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
    type = "disk";
    key = "Disk";
    keyIcon = "";
    folders = "/";
    useAvailable = true;
    format = "{size-used} / {size-total} ({size-percentage})";
  }
]
