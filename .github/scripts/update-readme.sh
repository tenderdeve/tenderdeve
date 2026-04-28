#!/usr/bin/env bash
# Refresh dynamic sections in README.md between START/END markers:
#   <!-- START:ecosystem -->    external PRs grouped by repo
#   <!-- START:activity  -->    true commit counts (rolling 365d + YTD)
set -euo pipefail

USER="tenderdeve"
README="README.md"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# --- Ecosystem: external PRs grouped by repo ---
gh search prs --author="$USER" --limit=100 --json repository,title,url,state \
  | jq -r --arg user "$USER" '
      [.[] | select(.repository.nameWithOwner | startswith($user + "/") | not)]
      | group_by(.repository.nameWithOwner)
      | map({
          repo: .[0].repository.nameWithOwner,
          count: length,
          prs: [.[] | {
            num: (.url | split("/") | .[-1]),
            url: .url,
            title: .title,
            state: .state
          }]
        })
      | sort_by(-.count)
      | map(
          "<details>\n"
          + "<summary><b><a href=\"https://github.com/" + .repo + "\">"
            + .repo
          + "</a></b> &middot; "
          + (.count | tostring) + " PR" + (if .count > 1 then "s" else "" end)
          + " &middot; <a href=\"https://github.com/" + .repo + "/pulls?q=author%3A" + $user + "+is%3Apr\">all →</a>"
          + "</summary>\n\n"
          + (.prs | map("- [`#" + .num + "`](" + .url + ") — " + .title) | join("\n"))
          + "\n\n</details>"
        )
      | join("\n\n")' > "$TMPDIR/ecosystem.md"

if [ ! -s "$TMPDIR/ecosystem.md" ]; then
  echo "_No external PRs yet._" > "$TMPDIR/ecosystem.md"
fi

# --- Activity: true commit count via parallel bare clones (all branches) ---
YEAR_NOW=$(date -u +"%Y")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

read -r ROLLING YTD < <(USER_LOGIN="$USER" bash "$SCRIPT_DIR/count-commits.sh")

fmt() { echo "$1" | sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta'; }
ROLLING_FMT=$(fmt "$ROLLING")
YTD_FMT=$(fmt "$YTD")

cat > "$TMPDIR/activity.md" <<EOF
| window | commits |
| --- | --- |
| rolling 365d | **$ROLLING_FMT** |
| ${YEAR_NOW} ytd | **$YTD_FMT** |
EOF

# --- Splice into README between markers ---
python3 - "$README" "$TMPDIR" <<'PY'
import re, sys, pathlib
readme_path, tmpdir = sys.argv[1], sys.argv[2]
data = pathlib.Path(readme_path).read_text()

for marker in ("ecosystem", "activity"):
    content = pathlib.Path(f"{tmpdir}/{marker}.md").read_text().rstrip()
    pat = re.compile(rf"(<!-- START:{marker} -->).*?(<!-- END:{marker} -->)", re.DOTALL)
    data = pat.sub(lambda m: f"{m.group(1)}\n{content}\n{m.group(2)}", data)

pathlib.Path(readme_path).write_text(data)
print(f"README updated: {readme_path}")
PY
