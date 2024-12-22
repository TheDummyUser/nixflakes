#!/usr/bin/env bash

pkill swayidle || swayidle
kill -SIGRTMIN+10 $(pgrep waybar)
