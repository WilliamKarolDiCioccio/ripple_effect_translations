#!/usr/bin/env bash
# Fails unless every non-merge commit in BASE..HEAD has a Signed-off-by
# trailer with its author's email. Emails are compared case-insensitively;
# the name is not compared, since people spell their own differently.
#
#   bash .github/sign-off.sh <base> <head>
set -euo pipefail
base=$1 head=$2
failed=0
for commit in $(git rev-list --no-merges "$base..$head"); do
  subject=$(git log -1 --format='%h %s' "$commit")
  author=$(git log -1 --format='%ae' "$commit" | tr '[:upper:]' '[:lower:]')
  signoffs=$(git log -1 --format='%(trailers:key=Signed-off-by,valueonly)' "$commit" |
    tr '[:upper:]' '[:lower:]')
  if [ -z "$signoffs" ]; then
    echo "::error::$subject has no Signed-off-by line."
    failed=1
  elif ! grep -q -F "<$author>" <<<"$signoffs"; then
    echo "::error::$subject is signed off, but not by its author <$author>."
    failed=1
  fi
done
if [ "$failed" = 1 ]; then
  echo "Sign off as the commit's author: 'git commit -s', or 'git rebase --signoff $base' for commits already made. CONTRIBUTING.md says why."
  exit 1
fi
