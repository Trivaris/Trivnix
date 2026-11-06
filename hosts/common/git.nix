{
  flake.homeModules.common-git = {
    userPrefs.git = {
      email = "git@trivaris.org";
      enableSigning = true;
      urlAliases = {
        "git@github.com:Trivaris/" = "triv:";
        "git@github.com:" = "github:";
      };
    };
  };
}
