#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch-git jq
#! vim: ft=bash
repo=$1
if [[ "$repo" != https://* ]]; then
    repo="https://github.com/$repo"
fi
info=$(nix-prefetch-git --quiet "$repo")
echo $info | jq .$2