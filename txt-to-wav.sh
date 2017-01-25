#!/bin/bash

TEMPFILE=$(mktemp XXXX.wav)
SAVEDIR=/tmp/

echo "$(xsel -o)" | espeak --stdin -w /$SAVEDIR/$TEMPFILE
