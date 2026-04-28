#!/usr/bin/env bash
# Refresh dynamic sections in README.md between START/END markers:
#   <!-- START:ecosystem -->    external PRs grouped by repo
#   <!-- START:activity  -->    true commit counts (rolling 365d + YTD)
set -euo pipefail

USER="tenderdeve"
README="README.md"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# --- Open Source Contributions: external public-repo PRs grouped by repo ---
# SKIP_ORGS lists owner namespaces to exclude (own profile + private/internal orgs).
SKIP_ORGS="${SKIP_ORGS:-$USER ANCILAR NonyaBTC}"

gh search prs --author="$USER" --limit=300 --json repository,title,url,state \
  | jq -r --arg skip "$SKIP_ORGS" '
      ($skip | split(" ")) as $skip_orgs
      | [.[] | select(
          .repository.nameWithOwner as $name
          | ($skip_orgs | any(. as $org | $name | startswith($org + "/"))) | not
        )]
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
      | sort_by(-.count)' > "$TMPDIR/contribs.json"

# Filter out repos that are private/non-public (network-bound visibility check).
# Cheaper than per-PR check, and the result list is short.
: > "$TMPDIR/public_repos"
jq -r '.[].repo' "$TMPDIR/contribs.json" | while read -r repo; do
  [ -z "$repo" ] && continue
  vis=$(gh api "repos/$repo" --jq '.visibility' 2>/dev/null || echo "")
  [ "$vis" = "public" ] && echo "$repo" >> "$TMPDIR/public_repos"
done

jq -r --rawfile pubs "$TMPDIR/public_repos" --arg user "$USER" '
    ($pubs | split("\n") | map(select(length > 0))) as $allowed
    | map(select(.repo as $r | $allowed | any(. == $r)))
    | map(
        (.repo | split("/")[0]) as $owner
        | "<details open>\n"
        + "<summary>"
        + "<img src=\"https://github.com/" + $owner + ".png?size=40\" "
          + "width=\"20\" height=\"20\" align=\"top\" "
          + "alt=\"" + $owner + "\" />"
        + "&nbsp; <b><a href=\"https://github.com/" + .repo + "\">"
          + .repo
        + "</a></b> &middot; "
        + (.count | tostring) + " PR" + (if .count > 1 then "s" else "" end)
        + " &middot; <a href=\"https://github.com/" + .repo + "/pulls?q=author%3A" + $user + "+is%3Apr\">all →</a>"
        + "</summary>\n\n"
        + (.prs | map("- [`#" + .num + "`](" + .url + ") — " + .title) | join("\n"))
        + "\n\n</details>"
      )
    | join("\n\n")' "$TMPDIR/contribs.json" > "$TMPDIR/ecosystem.md"

if [ ! -s "$TMPDIR/ecosystem.md" ]; then
  echo "_No public PRs yet._" > "$TMPDIR/ecosystem.md"
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
