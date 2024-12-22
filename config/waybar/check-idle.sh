#!/usr/bin/env bash

pid=$(pgrep swayidle)
kill -SIGRTMIN+10 $(pgrep waybar)
if [[ "$pid" == "" ]]; then echo ''; else echo ''; fi
