{ config, ... }:
{
  assertions = [
    {
      assertion = config.hostPrefs.forgejo.sendMails -> config.hostPrefs.mailserver.enable;
      message = ''Forgejo's Capability to send mails has been enabled, but the mailserver required to do so has not been.'';
    }
  ];
}
