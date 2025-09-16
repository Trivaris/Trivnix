{
  mainMonitorName,
  ...
}:
{
  general.hide_cursor = true;
  "$font" = "JetBrainsMono Nerd Font";

  background = {
    monitor = "";
    path = "screenshot";
    blur_passes = 5;
    blur_size = 8;
  };

  label = [
    {
      monitor = mainMonitorName;
      text = "Wake up, $USER...";
      font_size = 25;
      position = "30, -30";
      halign = "left";
      valign = "top";
    }
    {
      monitor = mainMonitorName;
      text = "$TIME";
      font_size = 90;
      font_family = "$font";
      position = "-30, 0";
      halign = "right";
      valign = "top";
    }
    {
      monitor = mainMonitorName;
      text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
      font_size = 25;
      font_family = "$font";
      position = "-30, -150";
      halign = "right";
      valign = "top";
    }
    {
      monitor = mainMonitorName;
      text = "$FPRINTPROMPT";
      font_size = 14;
      font_family = "$font";
      position = "0, -107";
      halign = "center";
      valign = "center";
    }
  ];

  image = {
    monitor = mainMonitorName;
    size = 100;
    position = "0, 75";
    halign = "center";
    valign = "center";
  };

  input-field = {
    monitor = mainMonitorName;
    size = "300, 60";
    outline_thickness = 4;
    dots_size = 0.2;
    dots_spacing = 0.2;
    dots_center = true;
    fade_on_empty = false;
    hide_input = false;
    fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
    position = "0, -47";
    halign = "center";
    valign = "center";
  };
}
