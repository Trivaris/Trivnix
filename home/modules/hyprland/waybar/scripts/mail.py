#!/usr/bin/python

import os, imaplib, json, subprocess, sys

def getpassword(cmd: str) -> str:
    return subprocess.check_output(cmd, shell=True, text=True).strip()

def getmails(username: str, password: str, host: str, port: str):
    imap = imaplib.IMAP4_SSL(host, int(port))
    imap.login(username, password)
    imap.select("INBOX")
    ustatus, uresponse = imap.uid("search", None, "UNSEEN")
    unread = uresponse[0].split() if ustatus == "OK" else []
    fstatus, fresponse = imap.uid("search", None, "FLAGGED")
    flagged = fresponse[0].split() if fstatus == "OK" else []
    return len(unread), len(flagged)

with open("~/.config/mailaccounts.json") as f:
    accounts = json.load(f)

results = {}
for name, data in accounts.items():
    host = data["host"]
    port = data["port"]

    if os.system(f"ping {host} -c1 > /dev/null 2>&1") != 0:
        continue

    password = getpassword(data["passwordCommand"])
    unread, flagged = getmails(data["username"], password, host, port)

    if unread > 0:
        alt = str(unread)
        if flagged > 0:
            alt = f"{flagged}  {alt}"
        results[name] = {"text": str(unread), "alt": alt}

if results:
    print(json.dumps(results))
    sys.exit(0)
else:
    sys.exit(1)