#!/bin/bash

set -e

STOP_SCRIPT="./stop-tfs.sh"
START_SCRIPT="./start-tfs.sh"

echo "Reiniciando TFS..."

if [ ! -x "$STOP_SCRIPT" ]; then
  echo "Script $STOP_SCRIPT não encontrado ou não executável"
  exit 1
fi

if [ ! -x "$START_SCRIPT" ]; then
  echo "Script $START_SCRIPT não encontrado ou não executável"
  exit 1
fi

$STOP_SCRIPT
sleep 2
$START_SCRIPT

echo "TFS reiniciado com sucesso"
