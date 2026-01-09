#!/bin/bash

set -e

SCREEN_NAME="tfs"

echo "Parando TFS..."

# Encerra a sessão screen se existir
if screen -list | grep -q "\.${SCREEN_NAME}"; then
  screen -S "$SCREEN_NAME" -X quit
  sleep 2
fi

# Garante que não ficou processo rodando
if pgrep -f theforgottenserver >/dev/null; then
  pkill -f theforgottenserver
  sleep 2
fi

# Limpa sessões mortas
screen -wipe >/dev/null 2>&1 || true

echo "TFS parado com sucesso"
