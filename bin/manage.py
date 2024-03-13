#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.argcomplete nvd git ripgrep
# PYTHON_ARGCOMPLETE_OK
# vim: ft=python
import socket
import argcomplete
import argparse
import os
import subprocess
from time import sleep


def checks():
    sudo = subprocess.run(["sudo", "-v"])
    if sudo.returncode != 0:
        exit(1)
    untracked_files()
    unpulled_commits()


def untracked_files():
    untracked = subprocess.run(
        "git ls-files --others --exclude-standard",
        capture_output=True,
        shell=True
    ).stdout.decode().strip()
    if untracked:
        print("Untracked files:")
        print(untracked)
        if ".nix" in untracked:
            exit(1)
        else:
            confirm = input("Continue? [y/N]: ")
            if confirm.lower() != "y":
                exit(1)


def git_diff():
    if not git_status():
        return
    subprocess.run(
        "git "
        "-c delta.side-by-side=false "
        "-c delta.hunk-header-style=\"omit\" "
        "diff -U0",
        shell=True
    )


def git_status():
    status = subprocess.run(
        "git status --porcelain",
        capture_output=True,
        shell=True
    ).stdout.decode().strip()
    return status


def unpulled_commits():
    subprocess.run(["git", "fetch"], capture_output=True)
    unpulled = subprocess.run(
        "git log HEAD..origin/main --oneline",
        capture_output=True,
        shell=True
    ).stdout.decode().strip()
    if unpulled and git_status():
        print("Unpulled commits:")
        print(unpulled)
        exit(1)
    elif unpulled:
        print("Unpulled commits")
        print("No local changes, pulling...")
        subprocess.run(["git", "pull"], capture_output=True)


def git_commit(message=None):
    if not git_status():
        return
    nix_generation = subprocess.run(
        "ls -v1 /nix/var/nix/profiles | tail -n 1 | cut -d- -f2",
        capture_output=True,
        shell=True
    ).stdout.decode().strip()
    hostname = socket.gethostname()
    hostname = hostname[0].upper() + hostname[1:]
    commit_message = f"{hostname} NixOS {nix_generation}"
    if message:
        commit_message += f": {message}"
    commit_status = subprocess.run(
        ["git", "commit", "-am", commit_message], capture_output=True)
    if commit_status.returncode != 0:
        print(commit_status.stderr.decode())
    push_status = subprocess.run(["git", "push"], capture_output=True)
    if push_status.returncode != 0:
        print(push_status.stderr.decode())
    print(commit_message)


def rebuild(method, **kwargs):
    rebuild_command = ["sudo", "nixos-rebuild", method, "--flake"]
    if host := kwargs.get("host"):
        rebuild_command.append(f".#{host}")
    else:
        rebuild_command.append(".")

    if kwargs.get("fast"):
        rebuild_command.append("--fast")
    if kwargs.get("debug"):
        rebuild_command.append("--show-trace")
    if build_host := kwargs.get("build_host"):
        rebuild_command.extend(["--build-host", build_host])
    if target_host := kwargs.get("target_host"):
        rebuild_command.extend(["--target-host", target_host])
    if kwargs.get("rollback"):
        rebuild_command = rebuild_command[:2] + ["switch", "--rollback"]
    try:
        with open("/tmp/nixos-rebuild.log", "w") as log:
            process = subprocess.Popen(rebuild_command, stdout=log, stderr=log)
            i = 0
            while process.poll() is None:
                spin = ["\\", "|", "/", "-"]
                if kwargs.get("host"):
                    print(
                        f"\rRebuilding NixOS configuration for {host} {spin[i]}", end="")
                else:
                    print(
                        f"\rRebuilding NixOS configuration for {socket.gethostname()} {spin[i]}", end="")
                i = (i + 1) % 4
                sleep(0.1)
            if process.returncode != 0:
                raise subprocess.CalledProcessError(
                    process.returncode, rebuild_command)
            else:
                print("\rRebuild successful\033[K")
    except subprocess.CalledProcessError:
        print("\rRebuild failed\033[K")
        print("See /tmp/nixos-rebuild.log for details")
        subprocess.run(
            r"rg --color always error\|\\w\+\.nix\*: /tmp/nixos-rebuild.log", shell=True)
        exit(1)


def update(flakes=None):
    command = ["nix", "flake", "update"]
    if flakes:
        command.extend(flakes)
    process = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    spin = ["\\", "|", "/", "-"]
    i = 0
    while process.poll() is None:
        print(f"\rUpdating flakes {spin[i]}", end="")
        i = (i + 1) % 4
        sleep(0.1)


def diff():
    out = subprocess.run(
        "ls -v1 /nix/var/nix/profiles | "
        "tail -n 2 | "
        "awk '{print \"/nix/var/nix/profiles/\" $0}' | "
        "xargs nvd --color always diff",
        capture_output=True,
        shell=True
    )
    lines = out.stdout.decode().split("\n")
    if lines:
        print("\n".join(lines[2:-2]))


def main():
    if not os.path.exists("flake.nix"):
        if not os.path.exists(os.path.expanduser("~/nixfiles/flake.nix")):
            print("This script must be run from NixOS configuration directory")
            exit(1)
        else:
            os.chdir(os.path.expanduser("~/nixfiles"))
    parser = argparse.ArgumentParser(description='Manage NixOS configuration')
    subparsers = parser.add_subparsers(dest="command")
    parser.add_argument("--no-commit", "-n",
                        action="store_true", help="Don't commit the changes")
    rebuild_parser = argparse.ArgumentParser(add_help=False)
    hosts = os.listdir("./hosts")
    rebuild_parser.add_argument(
        "--host", choices=hosts,
        help="The host to rebuild", required=(socket.gethostname() not in hosts)
    )
    rebuild_parser.add_argument(
        "--fast", "-f", action="store_true",
        help="Skip building nix for quicker rebuilds"
    )
    rebuild_parser.add_argument(
        "--debug", "-d", action="store_true", help="Enable debug output")
    rebuild_parser.add_argument("--build-host", help="The host to build on")
    rebuild_parser.add_argument(
        "--target-host", help="Where to deploy the build")

    rebuild_cmd_parser = subparsers.add_parser(
        "rebuild", help="Rebuild the system", parents=[rebuild_parser])
    rebuild_cmd_parser.add_argument(
        "message",
        nargs="?",
        help="The commit message to go with the rebuild",
        metavar="Commit message"
    )
    subparsers.add_parser(
        "upgrade", help="Update all flakes then rebuild", parents=[rebuild_parser])

    update_parser = subparsers.add_parser("update", help="Update flakes")
    update_parser.add_argument(
        "flakes", nargs="*", help="The flakes to update")
    subparsers.add_parser("test", help="Test the system")
    subparsers.add_parser("rollback", help="Rollback the system")
    subparsers.add_parser(
        "diff",
        help="List packages that have changed between"
        " the current and previous system generations"
    )

    argcomplete.autocomplete(parser)
    args = parser.parse_args()
    if args.command == "rebuild" or args.command is None:
        checks()
        git_diff()
        rebuild("switch", **vars(args))
        diff()
        if not args.no_commit:
            git_commit(message=args.message if args.command else None)
    elif args.command == "upgrade":
        checks()
        update()
        rebuild("switch", **vars(args))
        git_commit(message="Update flakes")
        diff()
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
        diff()


if __name__ == "__main__":
    main()
