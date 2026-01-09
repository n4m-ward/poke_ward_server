#!/bin/bash

set -e

SCREEN_NAME="tfs"
TFS_BIN="./theforgottenserver"  # executável na mesma pasta que o script
CPU_LIMIT=50                     # % da CPU
RAM_LIMIT=1258291                # ~1.2 GB em KB

# -----------------------------
# Verificação de dependências
# -----------------------------
echo "Verificando dependências..."

if ! command -v screen >/dev/null 2>&1; then
    echo "screen não encontrado. Instalando..."
    sudo apt update
    sudo apt install screen -y
fi

if ! command -v cpulimit >/dev/null 2>&1; then
    echo "cpulimit não encontrado. Instalando..."
    sudo apt update
    sudo apt install cpulimit -y
fi

if ! command -v awk >/dev/null 2>&1; then
    echo "awk não encontrado. Instalando..."
    sudo apt update
    sudo apt install gawk -y
fi

# -----------------------------
# Validações do TFS
# -----------------------------
if [ ! -x "$TFS_BIN" ]; then
    echo "Executável $TFS_BIN não encontrado ou sem permissão de execução"
    exit 1
fi

mkdir -p crashs

# -----------------------------
# Evita sessão duplicada
# -----------------------------
if screen -list | grep -q "\.${SCREEN_NAME}"; then
    echo "Sessão screen '$SCREEN_NAME' já existe"
    exit 1
fi


TIMESTAMP=$(date +"%F %H-%M-%S")
LOGFILE="crashs/$TIMESTAMP.log"

echo "Iniciando TFS com limites de CPU/RAM..."
screen -dmS "$SCREEN_NAME" bash -c "
    ulimit -v $RAM_LIMIT
    exec cpulimit -l $CPU_LIMIT $TFS_BIN 2>&1 | awk '{ print strftime(\"%F %T -\"), \$0; fflush(); }' | tee '$LOGFILE'
"

echo "TFS iniciado com sucesso!"
echo "Para acessar o console, use: screen -r $SCREEN_NAME"
