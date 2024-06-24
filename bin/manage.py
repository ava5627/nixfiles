#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.argcomplete nvd git ripgrep python3Packages.rich
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
        print("Untracked files:")
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
        subprocess.run(["git", "pull"], check=True, cwd=nvim_dir)
    qtile_dir = os.path.join(cfg_dir, "qtile")
    if os.path.exists(qtile_dir + "/.git") and not has_changes(qtile_dir):
        subprocess.run(["git", "pull"], check=True, cwd=qtile_dir)


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


def git_commit(message=None, host=None):
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
    hostname = hostname[0].upper() + hostname[1:]
    commit_message = f"{hostname} NixOS {nix_generation}"
    if message:
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
    rebuild_command = ["sudo", "nixos-rebuild", method, "--flake"]

    if target_host := kwargs.get("target_host"):
        if "@" in target_host:
            host = target_host.split("@")[-1]
        else:
            host = target_host
        ssh_open = subprocess.run(
            f"ssh -q -o ConnectTimeout=1 {target_host} true", shell=True
        )
        if ssh_open.returncode != 0:
            print(f"Could not connect to {target_host}")
            exit(1)
        print(f"Enabling root login on {host}, please enter password for {target_host}")
        copy = subprocess.run(
            ["ssh", "-t", target_host, "sudo cp -f ~/.ssh/authorized_keys /root/.ssh/"]
        )
        if copy.returncode != 0:
            print("[bold red]Failed[/bold red] to enable root login")
            exit(1)
        rebuild_command.remove("sudo")
        rebuild_command.append(f".#{host}")
        rebuild_command.extend(["--target-host", "root@" + host])
    elif host := kwargs.get("host"):
        rebuild_command.append(f".#{host}")
    else:
        host = socket.gethostname()
        rebuild_command.append(".")

    if build_host := kwargs.get("build_host"):
        rebuild_command.extend(["--build-host", build_host])
        host += f" (built on {build_host})"

    if kwargs.get("fast"):
        rebuild_command.append("--fast")
    if kwargs.get("debug"):
        rebuild_command.append("--show-trace")
    if kwargs.get("rollback"):
        rebuild_command = rebuild_command[:2] + ["switch", "--rollback"]
    try:
        run_in_box(
            rebuild_command,
            f"Rebuilding NixOS configuration for {host}",
            "/tmp/nixos-rebuild.log",
        )
    except subprocess.CalledProcessError:
        print("See /tmp/nixos-rebuild.log for details")
        subprocess.run(
            r"rg --color always error\|\\w\+\.nix\*: /tmp/nixos-rebuild.log",
            shell=True,
            check=True,
        )
        exit(1)
    finally:
        if target_host:
            print(f"Disabling root login on {host}")
            remove = subprocess.run(
                ["ssh", "-t", target_host, "sudo rm -f /root/.ssh/authorized_keys"]
            )
            if remove.returncode != 0:
                print(
                    "[bold yellow]Warning[/bold yellow]: Failed to disable root login"
                )
                print("Make sure to remove the key manually")


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
                if len(lines) > 10:
                    lines.pop(0)
                line = Text.from_ansi(line.strip()).plain
                lines.append(line.strip())
                panel.renderable = "\n".join(lines)
                if re.search(r"\b(error|failed|warning)\b:", line, re.IGNORECASE) and "Git tree" not in line:
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
    hosts = os.listdir("./hosts")
    rebuild_parser.add_argument(
        "--host",
        choices=hosts,
        help="The host to rebuild",
        required=(socket.gethostname() not in hosts),
    )
    rebuild_parser.add_argument(
        "--fast",
        "-f",
        action="store_true",
        help="Skip building nix for quicker rebuilds",
    )
    rebuild_parser.add_argument(
        "--debug", "-d", action="store_true", help="Enable debug output"
    )
    rebuild_parser.add_argument("--build-host", help="The host to build on")
    rebuild_parser.add_argument("--target-host", help="Where to deploy the build")

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
    subparsers.add_parser("rollback", help="Rollback the system")
    subparsers.add_parser(
        "diff",
        help="List packages that have changed between"
        " the current and previous system generations",
    )

    argcomplete.autocomplete(parser)
    args = parser.parse_args()
    if args.command == "rebuild":
        checks()
        # git_diff()
        rebuild("switch", **vars(args))
        version_diff()
        git_commit(message=args.message, host=args.host or args.target_host)
    if not args.command:
        checks()
        rebuild("switch")
        version_diff()
        if not args.no_commit:
            git_commit()
    elif args.command == "upgrade":
        checks()
        update()
        rebuild("switch", **vars(args))
        git_commit(message="Update flakes")
        version_diff()
    elif args.command == "update":
        checks()
        update(args.flakes)
    elif args.command == "test":
        checks()
        rebuild("test", fast=True)
    elif args.command == "rollback":
        subprocess.call(["sudo", "-v"])
        rebuild("switch", rollback=True)
    elif args.command == "diff":
        version_diff()


if __name__ == "__main__":
    main()
