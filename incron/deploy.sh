#!/bin/bash

source cfg.inc

echo "-=[ sync the web server content"

rsync -ratlz --rsh="/usr/bin/sshpass -p $INCRONPASS ssh -o StrictHostKeyChecking=no -l $INCRONUSER" \
    --exclude cfg.php \
    "web/" "$WEBSRV/"

echo "-=[ sync the backend incron scripts"

rsync -ratlz --rsh="/usr/bin/sshpass -p $INCRONPASS ssh -o StrictHostKeyChecking=no -l $INCRONUSER" \
    incron/ \
    "$SSH:$INCRONDIR/exec/"

echo "-=[ activate changes(incron) and make directories missing"
sshpass -p $INCRONPASS ssh -o StrictHostKeyChecking=no -l $INCRONUSER \
    $SSH "sudo bash -s" -- <rExec.sh \
    "$WEBCHOWN" \
    "$WEBDIR" \
    "$INCRONUSER" \
    "$INCRONSH" \
    "$INCRONDIR" \
    "$WEBURL"
