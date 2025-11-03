{ config, ... }:
{
  assertions = [
    {
      assertion = !(config.hostPrefs.ipsecClient.enable && config.hostPrefs.ipsecServer.enable);
      message = "Client and Server enabled. Please only use exactly one per machine";
    }
  ];
}
