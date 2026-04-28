#!/usr/bin/env bash
# Refresh dynamic sections in README.md between START/END markers:
#   <!-- START:projects   -->   top-N owned non-fork public repos
#   <!-- START:ecosystem  -->   external public-repo PRs grouped by repo (cards)
set -euo pipefail

USER="tenderdeve"
README="README.md"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# --- Projects: top-N owned non-fork public repos sorted by latest push ---
gh api "users/$USER/repos?per_page=100&sort=pushed&type=owner" \
  | jq -r --arg user "$USER" '
      [.[] | select(
          .fork == false
          and .private == false
          and .archived == false
          and .name != $user
          and (.description // "") != ""
        )][:6]
      | .[] | "\(.full_name)|\(.html_url)|\((.description) | gsub("\\|"; "\\|"))"' \
  > "$TMPDIR/repos_meta"

# Frontend-priority language resolution (TS / JS / Solidity > Rust / Go).
PRIORITY="TypeScript JavaScript Solidity Vyper Move Cairo Rust Go Python Swift Kotlin Java C++ C"
SKIP_LANGS="HTML CSS SCSS Shell Dockerfile Makefile Procfile MDX Nix HCL Roff Batchfile PowerShell"

resolve_stack() {
  local repo=$1
  gh api "repos/$repo/languages" 2>/dev/null \
    | jq -r --arg priority "$PRIORITY" --arg skip "$SKIP_LANGS" '
        ($skip | split(" ")) as $skip_arr
        | ($priority | split(" ")) as $prio_arr
        | to_entries
        | map(select(.key as $k | $skip_arr | index($k) | not))
        | . as $langs
        | ([$prio_arr[] as $p | $langs[] | select(.key == $p) | .key]
            + ($langs | sort_by(-.value) | map(.key)))
        | reduce .[] as $k ([]; if any(.[]; . == $k) then . else . + [$k] end)
        | .[0:2]
        | join(", ")
      '
}

{
  if [ ! -s "$TMPDIR/repos_meta" ]; then
    echo "_No public projects yet._"
  else
    # Read each row into shell array entries: "name|url|desc|stack"
    cards=()
    while IFS='|' read -r repo url desc; do
      stack=$(resolve_stack "$repo")
      [ -z "$stack" ] && stack="—"
      name="${repo#*/}"
      # Render stack as inline <code> chips
      stack_chips=$(echo "$stack" | sed -E 's/, /<\/code>\&nbsp;\&nbsp;<code>/g; s/^/<code>/; s/$/<\/code>/')
      card="<h3><a href=\"$url\">$name</a></h3>
<sub>$desc</sub><br/><br/>
<sub>$stack_chips</sub>"
      cards+=("$card")
    done < "$TMPDIR/repos_meta"

    # Wrap every 2 cards in a <tr> with two <td> cells (50% each).
    echo "<table width=\"100%\">"
    i=0
    while [ "$i" -lt "${#cards[@]}" ]; do
      echo "<tr>"
      printf '<td valign="top" width="50%%">\n\n%s\n\n</td>\n' "${cards[$i]}"
      j=$((i + 1))
      if [ "$j" -lt "${#cards[@]}" ]; then
        printf '<td valign="top" width="50%%">\n\n%s\n\n</td>\n' "${cards[$j]}"
      else
        echo '<td valign="top" width="50%"></td>'
      fi
      echo "</tr>"
      i=$((i + 2))
    done
    echo "</table>"
  fi
} > "$TMPDIR/projects.md"

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
        | "<details>\n"
        + "<summary>"
        + "<img src=\"https://github.com/" + $owner + ".png?size=40\" "
          + "width=\"20\" height=\"20\" align=\"top\" "
          + "alt=\"" + $owner + "\" />"
        + " <b><a href=\"https://github.com/" + .repo + "\">"
          + .repo
        + "</a></b> &middot; "
        + (.count | tostring) + " PR" + (if .count > 1 then "s" else "" end)
        + " &middot; <a href=\"https://github.com/" + .repo + "/pulls?q=author%3A" + $user + "+is%3Apr\">all →</a>"
        + "</summary>\n"
        + "<ul>\n"
        + (.prs | map("<li><a href=\"" + .url + "\"><code>#" + .num + "</code></a> — " + (.title | gsub("<"; "&lt;") | gsub(">"; "&gt;")) + "</li>") | join("\n"))
        + "\n</ul>\n"
        + "</details>"
      )
    | (
        if length == 0 then ""
        else
          [range(0; (length / 2 | ceil)) as $i | .[($i*2):($i*2+2)]]
          | map(
              "<tr>"
              + (
                  map("<td valign=\"top\" width=\"50%\">\n\n" + . + "\n\n</td>")
                  + (if length < 2 then ["<td valign=\"top\" width=\"50%\"></td>"] else [] end)
                  | join("")
                )
              + "</tr>"
            )
          | "<table width=\"100%\">\n" + join("\n") + "\n</table>"
        end
      )' "$TMPDIR/contribs.json" > "$TMPDIR/ecosystem.md"

if [ ! -s "$TMPDIR/ecosystem.md" ] || [ "$(cat "$TMPDIR/ecosystem.md")" = "" ]; then
  echo "_No public PRs yet._" > "$TMPDIR/ecosystem.md"
fi

# --- Splice into README between markers ---
python3 - "$README" "$TMPDIR" <<'PY'
import re, sys, pathlib
readme_path, tmpdir = sys.argv[1], sys.argv[2]
data = pathlib.Path(readme_path).read_text()

for marker in ("projects", "ecosystem"):
    content = pathlib.Path(f"{tmpdir}/{marker}.md").read_text().rstrip()
    pat = re.compile(rf"(<!-- START:{marker} -->).*?(<!-- END:{marker} -->)", re.DOTALL)
    data = pat.sub(lambda m: f"{m.group(1)}\n{content}\n{m.group(2)}", data)

pathlib.Path(readme_path).write_text(data)
print(f"README updated: {readme_path}")
PY
