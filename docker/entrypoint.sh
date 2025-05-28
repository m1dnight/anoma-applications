#!/bin/sh

epmd -d &
cd /opt/anoma

git fetch --all
git reset --hard origin/m1dnight/anoma-app-testbranch

iex -S mix phx.server --no-halt /run.exs