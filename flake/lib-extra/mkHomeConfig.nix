mkFlakePath:
config:
{ ... }:
{

  imports = [
    (mkFlakePath /home/common)
    (mkFlakePath /home/modules)
  ];

  inherit config;
  
}