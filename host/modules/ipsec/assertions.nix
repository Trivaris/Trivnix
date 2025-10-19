{ prefs }:
[
  {
    assertion =
      prefs.ipsec.asClient -> (prefs.ipsec.clientId != null && prefs.ipsec.clientCert != null);
    message = "Client config is enabled, but no cert is provided";
  }
]
