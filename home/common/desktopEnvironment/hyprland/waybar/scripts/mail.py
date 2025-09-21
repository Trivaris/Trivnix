#!/usr/bin/env python3

import argparse
import json
import imaplib
import socket
import ssl
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Tuple


CONFIG_PATH = Path.home() / ".config" / "mailaccounts.json"


def get_password(command: str) -> str:
    return subprocess.check_output(
        command,
        shell=True,
        text=True,
        stderr=subprocess.DEVNULL,
    ).strip()


def _open_connection(
    host: str,
    port: int,
    security: str,
    timeout: int,
    allow_fallback: bool = True,
) -> imaplib.IMAP4:
    mode = security.lower()

    try:
        if mode in {"plain", "none"}:
            return imaplib.IMAP4(host, port, timeout=timeout)
        if mode == "starttls":
            connection = imaplib.IMAP4(host, port, timeout=timeout)
            try:
                connection.starttls()
            except (imaplib.IMAP4.error, ssl.SSLError, OSError):
                try:
                    connection.logout()
                except Exception:
                    pass
                if allow_fallback:
                    return _open_connection(host, port, "ssl", timeout, allow_fallback=False)
                raise
            return connection
        return imaplib.IMAP4_SSL(host, port, timeout=timeout)
    except (TimeoutError, socket.timeout, OSError):
        if mode == "starttls" and allow_fallback:
            return _open_connection(host, port, "ssl", timeout, allow_fallback=False)
        raise


def count_messages(
    username: str,
    password: str,
    host: str,
    port: int,
    security: str,
    timeout: int,
) -> int:
    connection = _open_connection(host, port, security, timeout)

    try:
        connection.login(username, password)
        connection.select("INBOX")

        unread_status, unread_response = connection.uid("search", None, "UNSEEN")
        unread = (
            len(unread_response[0].split())
            if unread_status == "OK" and unread_response and unread_response[0]
            else 0
        )
        return unread
    finally:
        try:
            connection.logout()
        except Exception:
            pass


def load_accounts() -> Dict[str, Dict[str, str]]:
    if not CONFIG_PATH.exists():
        return {}

    with CONFIG_PATH.open() as handle:
        return json.load(handle)


def summarize_accounts(accounts: Dict[str, Dict[str, str]]) -> Tuple[List[str], int, bool]:
    summary_lines: List[str] = []
    total_unread = 0
    had_error = False

    for name, details in accounts.items():
        host = details.get("host")
        raw_port = details.get("port", 993)
        try:
            port = int(raw_port)
        except (TypeError, ValueError):
            port = 993
        username = details.get("username")
        address = details.get("address", "")
        password_command = details.get("passwordCommand", "")
        security = str(details.get("security", "")).lower()
        use_starttls = bool(details.get("useStartTls", False))

        if security in {"ssl", "starttls", "plain", "none"}:
            connection_mode = security
        else:
            connection_mode = ""

        if connection_mode in {"", "auto"}:
            if use_starttls:
                connection_mode = "starttls"
            elif port == 993:
                connection_mode = "ssl"
            else:
                connection_mode = "plain"

        if connection_mode == "plain" and use_starttls:
            connection_mode = "starttls"
        if connection_mode == "plain" and port == 993:
            connection_mode = "ssl"
        if connection_mode == "none":
            connection_mode = "plain"

        if not all([host, port, username, password_command]):
            summary_lines.append(f"{name}: ! missing configuration")
            had_error = True
            continue

        try:
            password = get_password(password_command)
            unread = count_messages(
                username=username,
                password=password,
                host=host,
                port=port,
                security=connection_mode,
                timeout=15,
            )
        except (subprocess.CalledProcessError, FileNotFoundError):
            summary_lines.append(f"{name}: ! password command failed")
            had_error = True
            continue
        except (imaplib.IMAP4.error, socket.timeout, TimeoutError, OSError) as exc:
            summary_lines.append(f"{name}: ! {exc.__class__.__name__}")
            had_error = True
            continue

        total_unread += unread
        display_name = address or username or name
        extras: List[str] = []

        if username and username != display_name:
            extras.append(f"user {username}")
        if host:
            extras.append(f"imap {host}:{port}")
        if connection_mode:
            extras.append(connection_mode.upper())

        extras_text = f" ({', '.join(extras)})" if extras else ""
        summary_lines.append(f"{display_name}: {unread}{extras_text}")

    if not summary_lines:
        summary_lines.append("No mailboxes configured")

    return summary_lines, total_unread, had_error


def render_json(summary: List[str], total_unread: int, had_error: bool) -> str:
    if had_error:
        alt = "error"
    elif total_unread > 0:
        alt = "unread"
    else:
        alt = "empty"

    text = str(total_unread)
    tooltip = "\n".join(summary)
    classes = ["mail", alt]

    return json.dumps({
        "text": text,
        "alt": alt,
        "tooltip": tooltip,
        "class": classes,
    })


def render_loading() -> str:
    return json.dumps({
        "text": "",
        "alt": "loading",
        "tooltip": "Checking mailboxes...",
        "class": ["mail", "loading"],
    })


def main() -> int:
    parser = argparse.ArgumentParser(description="Mail status helper for Waybar")
    parser.add_argument(
        "--summary",
        action="store_true",
        help="Print mailbox summary lines instead of Waybar JSON",
    )
    args = parser.parse_args()

    accounts = load_accounts()

    if args.summary:
        summary, _, _ = summarize_accounts(accounts)
        print("\n".join(summary))
        return 0

    print(render_loading(), flush=True)
    summary, total_unread, had_error = summarize_accounts(accounts)
    print(render_json(summary, total_unread, had_error), flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
