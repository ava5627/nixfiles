#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.argcomplete nvd git ripgrep python3Packages.rich nh
# PYTHON_ARGCOMPLETE_OK
import argparse
import json
import os
import re
import socket
import subprocess

import argcomplete
from rich import print
from rich.console import Group
from rich.live import Live
from rich.panel import Panel
from rich.prompt import Confirm
from rich.status import Status
from rich.text import Text


def checks():
    sudo = subprocess.run(["sudo", "-v"])
    if sudo.returncode != 0:
        exit(1)
    untracked_files()
    unpulled_commits()
    update_non_nix()


def untracked_files():
    untracked = (
        subprocess.run(
            "git ls-files --others --exclude-standard", capture_output=True, shell=True
        )
        .stdout.decode()
        .strip()
    )
    if untracked:
        print("[bod yellow]Untracked files:")
        print(untracked)
        if ".nix" in untracked:
            exit(1)
        else:
            if not Confirm.ask("Continue?", default=False):
                exit(1)


def update_non_nix():
    cfg_dir = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
    nvim_dir = os.path.join(cfg_dir, "nvim")
    if os.path.exists(nvim_dir + "/.git") and not has_changes(nvim_dir):
        subprocess.run(["git", "pull"], check=True, cwd=nvim_dir, capture_output=True)
    qtile_dir = os.path.join(cfg_dir, "qtile")
    if os.path.exists(qtile_dir + "/.git") and not has_changes(qtile_dir):
        subprocess.run(["git", "pull"], check=True, cwd=qtile_dir, capture_output=True)


def git_diff():
    if not has_changes():
        return
    subprocess.run(
        "git "
        "-c delta.side-by-side=false "
        '-c delta.hunk-header-style="omit" '
        "diff -U0",
        shell=True,
    )


def has_changes(dir=None):
    status = subprocess.run(
        "git diff HEAD --quiet",
        shell=True,
        cwd=dir,
    )
    return status.returncode != 0


def unpulled_commits():
    subprocess.run(["git", "fetch"], capture_output=True)
    unpulled = (
        subprocess.run(
            "git log HEAD..origin/main --oneline", capture_output=True, shell=True
        )
        .stdout.decode()
        .strip()
    )
    if unpulled and has_changes():
        print("Unpulled commits:")
        print(unpulled)
        exit(1)
    elif unpulled:
        print("Unpulled commits")
        print("No local changes, pulling...")
        pull = subprocess.run(["git", "pull"], capture_output=True)
        if pull.returncode != 0:
            print("[bold red]Failed[/bold red] to pull changes")
            print(pull.stderr.decode())
            exit(1)


def git_commit(message=None, host=None, message_only=False):
    if not has_changes():
        return
    nix_generation = (
        subprocess.run(
            "nixos-rebuild list-generations --json", capture_output=True, shell=True
        )
        .stdout.decode()
        .strip()
    )
    nix_generation = json.loads(nix_generation)[0]["generation"]
    hostname = host or socket.gethostname()
    hostname = hostname.title()
    commit_message = f"{hostname} NixOS {nix_generation}"
    if message_only and message:
        commit_message = message
    elif message:
        commit_message += f": {message}"
    commit_status = subprocess.run(
        ["git", "commit", "-am", commit_message], capture_output=True
    )
    if commit_status.returncode != 0:
        print(commit_status.stderr.decode())
    push_status = subprocess.run(["git", "push"], capture_output=True)
    if push_status.returncode != 0:
        print(push_status.stderr.decode())
    print(commit_message)


def rebuild(method, **kwargs):
    rebuild_command = ["nh", "os", method, "."]

    if host := kwargs.get("host"):
        rebuild_command.extend(["--hostname", host])

    if kwargs.get("debug"):
        rebuild_command.append("-v")

    if kwargs.get("dry_run"):
        rebuild_command.append("--dry-run")

    try:
        subprocess.run(rebuild_command, check=True)
    except subprocess.CalledProcessError:
        exit(1)


def run_in_box(command, title, file):
    with open(file, "w") as log:
        process = subprocess.Popen(
            command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT
        )
        panel = Panel("", highlight=True)
        status = Status(title)
        group = Group(status, panel)
        lines = []
        with Live(group, refresh_per_second=10) as live:
            while process.poll() is None:
                line = process.stdout.readline().decode()
                log.write(line)
                if len(lines) > 20:
                    lines.pop(0)
                line = Text.from_ansi(line.strip()).plain
                lines.append(line.strip())
                panel.renderable = "\n".join(lines)
                if (
                    re.search(r"\b(error|failed|warning)\b:", line, re.IGNORECASE)
                    and "Git tree" not in line
                ):
                    line = re.sub(
                        r"\b(error|failed)\b:",
                        "[bold red]\\1[/bold red]:",
                        line,
                        flags=re.IGNORECASE,
                    )
                    line = re.sub(
                        r"\b(warning)\b:",
                        "[bold yellow]\\1[/bold yellow]:",
                        line,
                        flags=re.IGNORECASE,
                    )
                    live.console.print(line.strip())
            if process.returncode != 0:
                live.update(f"[bold red]Failed[/bold red] {title}")
                raise subprocess.CalledProcessError(process.returncode, command)
            else:
                live.update(Text("Successful", style="bold green"))


def update(flakes=None):
    command = ["nix", "flake", "update"]
    if flakes:
        command.extend(flakes)
    run_in_box(command, "Updating flakes", "/tmp/nix-flake-update.log")


def version_diff():
    out = subprocess.run(
        "ls -v1 /nix/var/nix/profiles | "
        "tail -n 2 | "
        "awk '{print \"/nix/var/nix/profiles/\" $0}' | "
        "xargs nvd --color always diff",
        capture_output=True,
        shell=True,
    )
    lines = out.stdout.decode().split("\n")
    if lines:
        print(Text.from_ansi("\n".join(lines[2:-2])))


def main():
    # if not os.path.exists("flake.nix"):
    #     if not os.path.exists(os.path.expanduser("~/nixfiles/flake.nix")):
    #         print("This script must be run from NixOS configuration directory")
    #         exit(1)
    #     else:
    os.chdir(os.path.expanduser("~/nixfiles"))
    parser = argparse.ArgumentParser(description="Manage NixOS configuration")
    subparsers = parser.add_subparsers(dest="command")
    parser.add_argument(
        "--no-commit", "-n", action="store_true", help="Don't commit the changes"
    )
    rebuild_parser = argparse.ArgumentParser(add_help=False)
    hosts = [
        d for d in os.listdir("./hosts") if os.path.exists(f"./hosts/{d}/default.nix")
    ]
    rebuild_parser.add_argument(
        "--host",
        choices=hosts,
        help="The host to rebuild",
        required=(socket.gethostname() not in hosts),
    )
    rebuild_parser.add_argument(
        "--debug", "-d", action="store_true", help="Enable debug output"
    )
    rebuild_parser.add_argument(
        "--dry-run", action="store_true", help="Only print actions don't run them"
    )

    rebuild_cmd_parser = subparsers.add_parser(
        "rebuild", help="Rebuild the system", parents=[rebuild_parser]
    )
    rebuild_cmd_parser.add_argument(
        "message",
        nargs="?",
        help="The commit message to go with the rebuild",
        metavar="Commit message",
    )
    subparsers.add_parser(
        "upgrade", help="Update all flakes then rebuild", parents=[rebuild_parser]
    )

    update_parser = subparsers.add_parser("update", help="Update flakes")
    update_parser.add_argument("flakes", nargs="*", help="The flakes to update")
    subparsers.add_parser("test", help="Test the system")

    argcomplete.autocomplete(parser)
    args = parser.parse_args()
    if args.command == "rebuild":
        checks()
        rebuild("switch", **vars(args))
        if not args.no_commit:
            git_commit(message=args.message, host=args.host)
    if not args.command:
        checks()
        rebuild("switch")
        if not args.no_commit:
            git_commit()
    elif args.command == "upgrade":
        checks()
        update()
        git_commit(message="Update flakes", message_only=True)
        rebuild("switch", **vars(args))
    elif args.command == "update":
        checks()
        update(args.flakes)
    elif args.command == "test":
        checks()
        rebuild("test")


if __name__ == "__main__":
    main()
