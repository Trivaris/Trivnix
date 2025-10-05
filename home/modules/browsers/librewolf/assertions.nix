{ inputs, prefs }:
[
  {
    assertion = prefs.librewolf.betterfox -> inputs ? betterfox;
    message = ''LibreWolf: prefs.librewolf.betterfox = true but input "betterfox" is missing. Add the input or set the option to false.'';
  }
]
