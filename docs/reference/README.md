# Trivnix Option Reference

Generated standalone reference from the local trivnix module tree.

This reference covers the public Trivnix namespaces: `hostPrefs`, `userPrefs`, and derived `vars` values.

## NixOS and host options
## hostPrefs\.enableFingerPrintAuth



Whether to enable Fingerprint authentication for sudo\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.actual\.enable

Whether to enable Actual, the private financing and budgeting tool\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.actual\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.actual\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.actual\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.actual\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.actual\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.actual\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.actual\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.actual\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.affine\.enable



Whether to enable Affine, a note-taking app\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.affine\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.affine\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.affine\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.affine\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.affine\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.affine\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.affine\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.affine\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.affine\.sendMails



Whether to enable Mail account creation for Affine; details must still be entered in its admin panel\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.cfddns\.enable



Whether to enable Cloudflare DDNS service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.cfddns\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.cfddns\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.cfddns\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.cfddns\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.cfddns\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.cfddns\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.cfddns\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.cfddns\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.codeServer\.enable



Whether to enable Code-Server for remote VS Code access over HTTPS\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.codeServer\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.codeServer\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.codeServer\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.codeServer\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.codeServer\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.codeServer\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.codeServer\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.codeServer\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.collabora\.enable



Whether to enable Collabora Online for browser-based document editing\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.collabora\.nextcloudFQDNs



Fully qualified domain names of Nextcloud instances allowed to use this
Collabora Online service\. Set to null when Nextcloud integration is not used\.



*Type:*
null or (list of string)



*Default:*

```nix
null
```



*Example:*

```nix
[
  "nextcloud.example.com"
]
```



## hostPrefs\.collabora\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.collabora\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.collabora\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.collabora\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.collabora\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.collabora\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.collabora\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.collabora\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.evolution\.enable



Whether to enable Evolution API service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.evolution\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.evolution\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.evolution\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.evolution\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.evolution\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.evolution\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.evolution\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.evolution\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.forgejo\.enable



Whether to enable Forgejo Git hosting service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.forgejo\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.forgejo\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.forgejo\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.forgejo\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.forgejo\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.forgejo\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.forgejo\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.forgejo\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.forgejo\.sendMails



Whether to enable Mail delivery through the integrated mailserver\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.glances\.enable



Whether to enable Glances system monitoring API\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.glances\.port



TCP port on which the Glances API listens



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
61208
```



## hostPrefs\.grub\.enable



Whether to enable GRUB customization\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.headless



Whether to enable This host as a headless host without GUI features\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.homepage\.enable



Whether to enable Homepage service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.homepage\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.homepage\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.homepage\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.homepage\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.homepage\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.homepage\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.homepage\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.homepage\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.homepage\.serviceGroups



Homepage service groups written to the generated dashboard configuration\.
The default lists services registered with the shared reverse proxy\.



*Type:*
YAML 1\.1 value



*Default:*

```nix
[
  {
    Services = [ ];
  }
]
```



## hostPrefs\.homepage\.settings



Alias of ` services.homepage-dashboard.settings `\.



*Type:*
YAML 1\.1 value



*Default:*

```nix
null
```



## hostPrefs\.homepage\.widgets



Alias of ` services.homepage-dashboard.widgets `\.



*Type:*
YAML 1\.1 value



*Default:*

```nix
null
```



## hostPrefs\.language\.charset



Character set appended to locale definitions, typically ` UTF-8 `\.
Adjust only when targeting non-Unicode encodings for legacy software\.



*Type:*
string



*Default:*

```nix
"UTF-8"
```



## hostPrefs\.language\.keyMap



Console keyboard layout applied to virtual terminals and X11\.
Match this with the desired XKB layout string (e\.g\., ` us `, ` de `)\.



*Type:*
string



*Default:*

```nix
"us"
```



## hostPrefs\.language\.locale



Primary locale controlling interface language and formatting rules\.
Used for ` i18n.defaultLocale ` and influences system-wide translations\.



*Type:*
string



*Default:*

```nix
"en_US"
```



## hostPrefs\.language\.units



Locale responsible for measurement units and region-specific formats\.
Populates the LC_\* overrides for numbers, dates, and other unit settings\.



*Type:*
string



*Default:*

```nix
"de_DE"
```



## hostPrefs\.mailserver\.enable



Whether to enable Mailserver, Postfix, and Dovecot for local email acceptance and delivery\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.mailserver\.accounts



Alias of ` mailserver.accounts `\.



*Type:*
submodule



## hostPrefs\.mailserver\.domain



Primary zone for MX/SRV records, autogenerated aliases, and ACME certificate requests



*Type:*
null or string



*Default:*

```nix
null
```



## hostPrefs\.mailserver\.extraDomains



List of additional subdomains of the specified domain authorized for email delivery



*Type:*
list of string



*Default:*

```nix
[ ]
```



## hostPrefs\.mailserver\.imapPort



TCP port used by the IMAP service (message retrieval)\.
Common values: 993 (imaps, implicit TLS) or 143 (imap, STARTTLS)\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
993
```



## hostPrefs\.mailserver\.providerName



Human-readable name displayed in client autoconfiguration dialogs via AutoMX



*Type:*
null or string



*Default:*

```nix
null
```



## hostPrefs\.mailserver\.smtpPort



TCP port used by the SMTP service (submission)\.
Common values: 587 (submission, STARTTLS) or 465 (smtps, implicit TLS)\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
587
```



## hostPrefs\.mainUser



Primary user account considered owner of the host configuration\.
Used by modules such as autologin and service defaults needing a username\.



*Type:*
string



*Default:*

```nix
builtins.head allUserInfos
```



## hostPrefs\.matrix\.enable



Whether to enable Matrix Conduit server\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.matrix\.name



Public Matrix server name, defaulting to the reverse-proxy domain



*Type:*
string



*Default:*

```nix
"matrix-server"
```



## hostPrefs\.matrix\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.matrix\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.matrix\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.matrix\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.matrix\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.matrix\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.matrix\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.matrix\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.n8n\.enable



Whether to enable n8n, the automation platform\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.n8n\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.n8n\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.n8n\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.n8n\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.n8n\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.n8n\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.n8n\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.n8n\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.oldProfileDeleteInterval



Maximum age for system profiles before garbage collection removes them\.
Passed directly to ` nix-collect-garbage --delete-older-than `\.



*Type:*
string



*Default:*

```nix
"3d"
```



## hostPrefs\.openconnectClient\.enable



Whether to enable VPN connection with the OpenConnect client\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.openconnectClient\.authgroup



Optional authentication group selected on the VPN gateway



*Type:*
null or string



*Default:*

```nix
null
```



## hostPrefs\.openconnectClient\.cafile



Optional path to a CA certificate used to verify the VPN server



*Type:*
null or absolute path



*Default:*

```nix
null
```



## hostPrefs\.openconnectClient\.gateway



Fully qualified domain name of the VPN gateway



*Type:*
string



## hostPrefs\.openconnectClient\.user



Username used to authenticate with the VPN gateway



*Type:*
string



## hostPrefs\.openssh\.enable



Whether to enable OpenSSH service and Exposure through firewall\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.openssh\.ports



TCP port the OpenSSH daemon will listen on\.
Ensure this port is allowed through the firewall if accessing remotely\.



*Type:*
list of 16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
[
  22
]
```



## hostPrefs\.paperless\.enable



Whether to enable Paperless, a document management service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.paperless\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.paperless\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.paperless\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.paperless\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.paperless\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.paperless\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.paperless\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.paperless\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.piHole\.enable



Whether to enable Pi-hole as a DNS sinkhole\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.piHole\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.piHole\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.piHole\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.piHole\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.piHole\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.piHole\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.piHole\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.piHole\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.reverseProxy\.enable



Whether to enable Nginx reverse proxy, shared for web services\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.reverseProxy\.enableDDClient



Whether to enable ddclient for dynamic DNS updates for the configured zone\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.reverseProxy\.ddnsTime



Systemd OnCalendar expression controlling when ddclient runs\.
Leave null to disable the timer or provide values like “daily” or “04:00”\.



*Type:*
null or string



*Default:*

```nix
null
```



*Example:*

```nix
"04:00"
```



## hostPrefs\.reverseProxy\.dumbPipes\.enable



Whether to enable non-HTTP forwarding rules handled by the shared reverse proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.reverseProxy\.dumbPipes\.fallbackPort



Port used when a dumb forwarding rule does not specify another target\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
8443
```



## hostPrefs\.reverseProxy\.dumbPipes\.pipes



TCP forwarding rules selected by the requested SNI hostname\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



## hostPrefs\.reverseProxy\.dumbPipes\.portForwards



Raw TCP port forwarding for protocols without SNI, such as SSH\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```



## hostPrefs\.reverseProxy\.dumbPipes\.portForwards\.\<name>\.enableTCP



Whether to enable TCP port forwarding\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.reverseProxy\.dumbPipes\.portForwards\.\<name>\.enableUDP



Whether to enable UDP port forwarding\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.reverseProxy\.dumbPipes\.portForwards\.\<name>\.listenPort



Local port that accepts forwarded connections



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.reverseProxy\.dumbPipes\.portForwards\.\<name>\.upstream



Address and port of the forwarding destination



*Type:*
string



## hostPrefs\.reverseProxy\.dumbPipes\.upstreams



Named upstream addresses used by dumb forwarding rules\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```



## hostPrefs\.reverseProxy\.dumbPipes\.upstreams\.\<name>\.address



Address of the upstream service



*Type:*
string



## hostPrefs\.reverseProxy\.dumbPipes\.upstreams\.\<name>\.port



Port of the upstream service



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
443
```



## hostPrefs\.reverseProxy\.email



Email address used for Let’s Encrypt/ACME certificate requests\.
Required for domain validation and renewal notices\.



*Type:*
string



*Example:*

```nix
"admin@example.com"
```



## hostPrefs\.reverseProxy\.extraCertDomains



Additional FQDNs to include in HTTPS Cert generation\.
These do not need to be linked to services managed by this reverse proxy\.



*Type:*
list of string



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "vpn.example.com"
  "blog.example.com"
]
```



## hostPrefs\.reverseProxy\.extraDDNSDomains



Additional FQDNs to include in DDNS updates\.
These do not need to be linked to services managed by this reverse proxy\.



*Type:*
list of string



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "vpn.example.com"
  "blog.example.com"
]
```



## hostPrefs\.reverseProxy\.extraServices



Additional services to register with the shared reverse proxy\.
Each entry extends the standard reverse-proxy service options with a name\.



*Type:*
list of (submodule)



*Default:*

```nix
[ ]
```



## hostPrefs\.reverseProxy\.extraServices\.\*\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.reverseProxy\.extraServices\.\*\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.reverseProxy\.extraServices\.\*\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.reverseProxy\.extraServices\.\*\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.reverseProxy\.extraServices\.\*\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.reverseProxy\.extraServices\.\*\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.reverseProxy\.extraServices\.\*\.name



Name used to identify the additional reverse-proxy service



*Type:*
string



## hostPrefs\.reverseProxy\.extraServices\.\*\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.reverseProxy\.zone



The DNS zone managed by Cloudflare (e\.g\., your root domain)\.
This is used to determine which domain records DDNS will update\.



*Type:*
string



*Example:*

```nix
"example.com"
```



## hostPrefs\.steam\.enable



Whether to enable Steam with bundled compatibility tooling on this host\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.syncthing\.enable



Whether to enable Syncthing, a file synchronization service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.syncthing\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.syncthing\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.syncthing\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.syncthing\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.syncthing\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.syncthing\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.syncthing\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.syncthing\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.tandoor\.enable



Whether to enable Tandoor Recipes, a self-hosted recipe manager\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.tandoor\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.tandoor\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.tandoor\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.tandoor\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.tandoor\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.tandoor\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.tandoor\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.tandoor\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.vaultwarden\.enable



Whether to enable Vaultwarden, a password manager backend\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.vaultwarden\.reverseProxy



List of services with name, ports, and domain\.



*Type:*
submodule



## hostPrefs\.vaultwarden\.reverseProxy\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.vaultwarden\.reverseProxy\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.vaultwarden\.reverseProxy\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## hostPrefs\.vaultwarden\.reverseProxy\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## hostPrefs\.vaultwarden\.reverseProxy\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## hostPrefs\.vaultwarden\.reverseProxy\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.vaultwarden\.reverseProxy\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## hostPrefs\.vaultwarden\.sendMails



Whether to enable Mail delivery through the integrated mailserver\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.wireguard\.enable



Whether to enable WireGuard client connection\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## hostPrefs\.wireguard\.address



Address and prefix assigned to the WireGuard interface



*Type:*
string



*Default:*

```nix
"10.0.0.1/24"
```



## hostPrefs\.wireguard\.interfaceName



Name of the WireGuard network interface



*Type:*
string



*Default:*

```nix
"wg0"
```



## hostPrefs\.wireguard\.peers



WireGuard peers and the traffic routed through each peer



*Type:*
list of (submodule)



## hostPrefs\.wireguard\.peers\.\*\.allowedIPs



IP ranges routed through this peer



*Type:*
list of string



*Default:*

```nix
[ ]
```



## hostPrefs\.wireguard\.peers\.\*\.endpoint



Optional endpoint address and port for the peer



*Type:*
null or string



*Default:*

```nix
null
```



## hostPrefs\.wireguard\.peers\.\*\.persistentKeepalive



Optional keepalive interval in seconds for NAT traversal



*Type:*
null or signed integer



*Default:*

```nix
null
```



## hostPrefs\.wireguard\.peers\.\*\.publicKey



Public key identifying the WireGuard peer



*Type:*
string



## hostPrefs\.wireguard\.port



UDP port used by the WireGuard interface



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



*Default:*

```nix
51820
```



## vars\.activeServices



Services collected from enabled reverse-proxy registrations



*Type:*
list of (submodule) *(read only)*



*Default:*

```nix
[ ]
```



## vars\.activeServices\.\*\.enable



Whether to enable Reverse Proxy\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## vars\.activeServices\.\*\.enableAnubis



Whether to enable Anubis\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## vars\.activeServices\.\*\.address



The internal ip address of the service



*Type:*
string



*Default:*

```nix
"127.0.0.1"
```



## vars\.activeServices\.\*\.domain



Domain for the service\.



*Type:*
string



*Example:*

```nix
"service.example.com"
```



## vars\.activeServices\.\*\.externalPort



External port for the service\.



*Type:*
signed integer



*Default:*

```nix
443
```



## vars\.activeServices\.\*\.https



Whether to enable Routing through https behind the reverse proxy for service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## vars\.activeServices\.\*\.name



Name of the active service registered with the reverse proxy



*Type:*
string



## vars\.activeServices\.\*\.port



Internal service port\.



*Type:*
16 bit unsigned integer; between 0 and 65535 (both inclusive)



## Home Manager options

## \<name>\.userPrefs\.cli\.enable

Whether to enable Replacement of selected default CLI utilities with the configured alternatives\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.email\.enable



Whether to enable SOPS-backed email account provisioning for this user\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.email\.enableThunderbirdIntegration



Allow this module to auto-configure Thunderbird profiles from secrets\.
Disable if you prefer to manage Thunderbird settings manually\.



*Type:*
boolean



*Default:*

```nix
true
```



## \<name>\.userPrefs\.email\.exclude



Email account identifiers to ignore when provisioning profiles\.
Filter names listed under ` config.private.emailAccounts.<user> `\.



*Type:*
list of impossible (empty enum)



*Default:*

```nix
[ ]
```



## \<name>\.userPrefs\.email\.generateAccountsFile



Control whether a JSON summary of filtered accounts is written\.
Set to false when an external tool manages ` mailaccounts.json `\.



*Type:*
boolean



*Default:*

```nix
true
```



## \<name>\.userPrefs\.git\.enableSigning



Whether to enable Commit and Tag signing in Git using an SSH key configured through sops-nix\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.git\.email



Email address written to the global Git config as ` user.email `\.
Match your forge account address so commits stay attributed correctly\.



*Type:*
string



*Example:*

```nix
"you@example.com"
```



## \<name>\.userPrefs\.git\.name



Name written to the global Git config as ` user.name `\.
Match your forge account name so commits stay attributed correctly\.



*Type:*
string



*Default:*

```nix
""
```



*Example:*

```nix
"trivaris"
```



## \<name>\.userPrefs\.git\.urlAliases



Git URL rewrite rules applied to the global Git configuration\.
Each attribute maps a source prefix to its replacement prefix\.



*Type:*
attribute set of string



*Default:*

```nix
{ }
```



*Example:*

```nix
{
  "git@github.com:example/" = "example:";
}
```



## \<name>\.userPrefs\.librewolf\.enable



Whether to enable LibreWolf, a privacy focused Browser\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.librewolf\.allowedCookies



Sites whose cookies are preserved when the browser closes



*Type:*
list of string



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "https://accounts.google.com"
]
```



## \<name>\.userPrefs\.prismlauncher\.enable



Whether to enable Prism Launcher configuration\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.quickshell\.wsIconOverrides



Rules that override the icon, text, and color used for matching application identifiers\.



*Type:*
list of (submodule)



*Default:*

```nix
[
  {
    color = "#ca9ee6";
    regex = "/spotify|music|feishin/";
    text = "";
  }
  {
    color = "#e78284";
    regex = "/firefox|zen|chromium|librewolf/";
    text = "󰈹";
  }
  {
    color = "#8caaee";
    regex = "/discord|vesktop|webcord/";
    text = "";
  }
  {
    color = "#e5c890";
    regex = "/steam/";
    text = "󰓓";
  }
  {
    color = "#8caaee";
    regex = "/thunderbird/";
    text = "";
  }
  {
    color = "#a6d189";
    regex = "/~|zsh|foot|kitty|alacritty|terminal/";
    text = "";
  }
  {
    color = "#81c8be";
    regex = "/code/";
    text = "";
  }
]
```



## \<name>\.userPrefs\.quickshell\.wsIconOverrides\.\*\.color



Color applied to the displayed icon



*Type:*
string



## \<name>\.userPrefs\.quickshell\.wsIconOverrides\.\*\.regex



Regular expression matched against an application identifier



*Type:*
string



## \<name>\.userPrefs\.quickshell\.wsIconOverrides\.\*\.text



Icon text displayed for matching applications



*Type:*
string



## \<name>\.userPrefs\.remmina\.enable



Whether to enable Remmina remote desktop client\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.syncthing\.enable



Whether to enable Syncthing, a file synchronization service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.thunderbird\.enable



Whether to enable Thunderbird configuration\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.vscode\.enable



Whether to enable VSCode, a lightweight code editor\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.wayvnc\.enable



Whether to enable Remote desktop access via WayVNC\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## \<name>\.userPrefs\.weatherLocation



Location query passed to the Waybar weather script (e\.g\. ` "berlin" ` or ` "48.85,2.35" `)\.
Leave ` null ` to let wttr\.in detect the location automatically from the current IP address\.



*Type:*
null or string



*Default:*

```nix
null
```



## \<name>\.vars\.filteredEmailAccounts



Email accounts after applying ` userPrefs.email.exclude `\.
This derived value is consumed by account and Thunderbird configuration\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
{ }
```



## \<name>\.vars\.shellAbbreviations



Shell abbreviations made available to the configured Zsh session



*Type:*
attribute set of anything *(read only)*



*Default:*

```nix
{
  ".." = "cd .";
  "..." = "cd ../../";
  gadd = "git add .";
  gchore = "git commit -m \"chore:";
  gclone = "git clone";
  gcomm = "git commit -m \"";
  gfeat = "git commit -m \"feat:";
  gpull = "git pull";
  gpush = "git push";
  gstat = "git status --short";
  gupdate = "git commit -m \"update:";
  ls = "ls";
}
```



## \<name>\.vars\.shellFunctions



Shell functions, including local check and rebuild helpers



*Type:*
attribute set of anything *(read only)*



*Default:*

```nix
{
  check = ''
    set prod 0
    set path "."
    set path_set 0
    
    for arg in $argv
      if test "$arg" = "--prod"
        set prod 1
      else if test $path_set -eq 0
        set path $arg
        set path_set 1
      else
        echo "Usage: check [--prod] [path=. ]"
        return 1
      end
    end
    
    if test $prod -eq 1
      nix flake check $path
    else
      nix flake check $path \
        --override-input trivnixConfigs ../TrivnixConfigs/ \
        --override-input trivnixLib     ../TrivnixLib/ \
        --override-input trivnixPrivate ../TrivnixPrivate/ \
        --override-input trivnixOverlays ../TrivnixOverlays/
    end
  '';
  rebuild = ''
    set prod 0
    set host ""
    set host_set 0
    
    for arg in $argv
      if test "$arg" = "--prod"
        set prod 1
      else if test $host_set -eq 0
        set host $arg
        set host_set 1
      else
        echo "Usage: rebuild [--prod] [host]"
        return 1
      end
    end
    
    if test $prod -eq 1
      sudo nixos-rebuild switch --flake ".#$host"
    else
      sudo nixos-rebuild switch --flake ".#$host" \
        --override-input trivnixConfigs ../TrivnixConfigs/ \
        --override-input trivnixLib     ../TrivnixLib/ \
        --override-input trivnixPrivate ../TrivnixPrivate/ \
        --override-input trivnixOverlays ../TrivnixOverlays/
    end
  '';
}
```



## \<name>\.vars\.terminalEmulator



Terminal emulator selected by the desktop configuration



*Type:*
string *(read only)*



*Default:*

```nix
"kitty"
```


