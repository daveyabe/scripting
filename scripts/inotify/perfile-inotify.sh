#!/bin/sh
#inotify per file then curl appropriate github action
inotifywait -m --includei 'PROJECTNAME*' -e close_write /root/project |
while read -r line
        do
        if echo $line; then \
        sleep 3;
        ( curl \
        -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token github_pat_somenumbersandletters" \
        https://api.github.com/repos/somewhere/reponame/actions/workflows/run-pipeline.yml/dispatches \
        -d '{"ref":"refs/heads/main", "inputs": { "ENVIRONMENT":"PRODUCTION"}}' ) &
        fi
done
