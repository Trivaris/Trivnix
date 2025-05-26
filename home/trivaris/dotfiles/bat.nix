{
  inputs,
  ...
}: {

  home.file.".config/bat/config".text = ''
    --theme="Dracula"
    --style="numbers,changes,header"
  '';

}