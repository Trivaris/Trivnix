{ inputs, hostInfos }:
[
  {
    assertion = builtins.hasAttr hostInfos.architecture inputs.hyprland.packages;
    message = "Hyprland: architecture ${hostInfos.architecture} not available in inputs.hyprland.packages";
  }
]
