#!/bin/bash

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [[ -n "$branch" ]]; then
  echo "{\"text\": \" $branch\", \"class\": \"git_branch\"}"
else
  echo "{\"text\": \"no git\"}"
fi
