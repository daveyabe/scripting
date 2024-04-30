#!/bin/sh
ps uxa | grep .vscode-server | awk '{print $2}' | xargs kill -9
