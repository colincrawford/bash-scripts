#!/bin/bash
set -e

BRANCHES=$(git branch -a | cat | grep "remotes/origin/dependabot")

git checkout dev

for branch in $BRANCHES
do
    echo "merging branch $branch"
    git merge --no-edit $branch
    sleep 2
done

echo "Done"
sleep 5


