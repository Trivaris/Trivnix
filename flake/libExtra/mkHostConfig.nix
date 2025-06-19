mkFlakePath:
{
  extraImports ? [ ],
  config
}:
{

  imports = [
    (mkFlakePath /hosts/common)
    (mkFlakePath /hosts/modules)
  ] ++ extraImports;

  inherit config;

}