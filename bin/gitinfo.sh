#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch-git jaq
#! vim: ft=bash
repo=$1
if [[ "$repo" != https://* ]]; then
    repo="https://github.com/$repo"
fi
if [[ $nargs -eq 2 ]]; then
    info=$(nix-prefetch-git --quiet "$repo")
else
    other_args=${@:3}
    info=$(nix-prefetch-git --quiet "$repo" $other_args)
fi
echo $info | jq
