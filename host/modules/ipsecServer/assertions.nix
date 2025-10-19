{ prefs }:
[
  {
    assertion = !(prefs.ipsecClient.enable && prefs.ipsecServer.enable);
    message = "Client and Server enabled. Please only use exactly one per machine";
  }
]
