#!/bin/sh
inotifywait -m --include 'PROJ*' -e create /root/project |
while read -r dir
        do
        if echo $dir | grep -qie "ISDIR"; then \
        sleep 300;
        ( curl \
        -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token github_pat_somelettersandnumbers" \
        https://api.github.com/repos/org/repo/actions/workflows/tri-build.yml/dispatches \
        -d '{"ref":"refs/heads/main", "inputs": { "ENVIRONMENT":"PRODUCTION"}}' ) &
        fi
done
