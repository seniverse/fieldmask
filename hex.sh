#!/usr/bin/env bash

set -e

rebar3 do hex config username "$1", hex config key "$2", hex publish, hex docs <<EOF
y
EOF
