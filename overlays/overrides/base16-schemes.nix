pkgs:
{
  src = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "317a5e10c35825a6c905d912e480dfe8e71c7559";
    hash = "sha256-d4km8W7w2zCUEmPAPUoLk1NlYrGODuVa3P7St+UrqkM=";
  };
}