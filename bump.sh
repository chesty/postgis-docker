#!/bin/sh

set -x

bump() {
  BRANCH="$1"
  if [ -z "$BRANCH" ]; then
    echo "usage: $0 <branch>"
    exit 1
  fi

  if git status | grep -q 'modified:'; then
    echo "modified files detected, commit or stash and rerun"
    exit 2
  fi

  git checkout "$BRANCH"
  git pull

  DATE=$(date +%Y%m%d.1)

  for DF in `find -name 'Dockerfile'`; do
  	sed -i "s/ENV BUMP .*/ENV BUMP $DATE/" "$DF"
    git stage "$DF"
  done
  git commit -m "bump $DATE"
  git push origin "$BRANCH"
}

bump master
