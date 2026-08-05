gfgc() {
  git fetch && git checkout "$1" && git pull
}

# reviewr: change the base branch for the `branch` scope (then press `r` in the sidebar)
_reviewr_base() {
  local dir=~/.config/herdr/plugins/config/persiyanov.reviewr
  local -a list=("$1") b
  for b in main master; do [[ $b == $1 ]] || list+=($b); done
  printf 'base_branches = ["%s"]\n' "${(j:", ":)list}" > "$dir/config.toml.new"
  mv "$dir/config.toml.new" "$dir/config.toml"
  echo "reviewr base → $1 (press r in the sidebar)"
}

# reviewr: grab the base branch from the current branch's open PR
rbpr() {
  local base
  base=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null) || {
    echo "reviewr: this branch has no open PR" >&2
    return 1
  }
  [[ -n $base ]] || {
    echo "reviewr: gh returned no base branch" >&2
    return 1
  }
  _reviewr_base "$base"
}

# reviewr: open the review in this terminal (standalone, `q` to quit)
rv() {
  local -a root=($HOME/.config/herdr/plugins/github/persiyanov.reviewr-*(N))
  (( $#root )) || {
    echo "reviewr: could not find the installed plugin" >&2
    return 1
  }
  # herdr only injects this variable into the plugin pane; without it the binary ignores config.toml
  HERDR_PLUGIN_CONFIG_DIR=$HOME/.config/herdr/plugins/config/persiyanov.reviewr \
    "$root[1]/bin/herdr-reviewr" "$@"
}
