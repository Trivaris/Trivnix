{ prefs }:
[
  {
    assertion = prefs.vaultwarden.sendMails -> prefs.mailserver.enable;
    message = ''Vaultwarden's Capability to send mails has been enabled, but the mailserver required to do so has not been.'';
  }
]
