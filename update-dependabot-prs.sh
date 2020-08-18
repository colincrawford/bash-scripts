#!/bin/bash
set -e

BRANCHES=$(git branch -a | cat | grep "remotes/origin/dependabot")
for branch in $BRANCHES
do
    echo "merging branch $branch"
    git checkout --track $branch
    git merge dev
    git push
    sleep 5
done
echo "Done"
sleep 5
git checkout dev
