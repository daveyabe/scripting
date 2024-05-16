#!/bin/sh

pm2 restart all
sleep 5
pm2 list
