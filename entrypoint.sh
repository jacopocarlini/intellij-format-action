#!/bin/bash

if [[ $# -ne 6 ]]; then
  echo 'Exactly six parameters required.'
  exit 1
fi

github_ref=$1
github_token=$2
base_path=$3
include_pattern=$4
fail_on_changes=$5
auto_fix=$6

# Prepare the workspace for safe usage:
git config --global --add safe.directory /github/workspace

git checkout $github_ref

ls
cd "/github/workspace/$base_path" || exit 2
changed_files_before=$(git status --short)

/opt/idea/bin/format.sh -m $include_pattern -r .

changed_files_after=$(git status --short)
changed_files=$(diff <(echo "$changed_files_before") <(echo "$changed_files_after"))
changed_files_count=$(($(echo "$changed_files" | wc --lines) - 1))

echo "$changed_files"
echo "files-changed=$changed_files_count" >> $GITHUB_OUTPUT

if [[ "$fail_on_changes" == 'true' ]]; then
  if [[ $changed_files_count -gt 0 ]]; then
    echo 'Failing, because these files changed:'
    exit 1
  fi
fi


if [[ "$auto_fix" == 'true' ]]; then
  git config --global user.name 'Your Name'
  git config --global user.email 'your-username@users.noreply.github.com'
  git add .
  git commit -m "IntelliJ Formatting code"
  git push origin HEAD:$github_ref
fi

