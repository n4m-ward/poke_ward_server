#!/bin/bash

BIN="./theforgottenserver"

if [ ! -f "$BIN" ]; then
  echo "Erro: theforgottenserver não encontrado no diretório atual"
  exit 1
fi

echo "Verificando bibliotecas faltantes..."
MISSING_LIBS=$(ldd "$BIN" | grep "not found" | awk '{print $1}')

if [ -z "$MISSING_LIBS" ]; then
  echo "Nenhuma biblioteca faltante."
  exit 0
fi

echo "Bibliotecas faltantes detectadas:"
echo "$MISSING_LIBS"
echo

sudo apt update

for LIB in $MISSING_LIBS; do
  case "$LIB" in
    liblua5.1.so.0)
      echo "Instalando Lua 5.1..."
      sudo apt install -y liblua5.1-0 || {
        echo "Tentando compatibilidade via liblua5.3..."
        sudo apt install -y liblua5.3-0
        if [ ! -f /usr/lib/x86_64-linux-gnu/liblua5.1.so.0 ]; then
          sudo ln -s /usr/lib/x86_64-linux-gnu/liblua5.3.so.0 \
                     /usr/lib/x86_64-linux-gnu/liblua5.1.so.0
        fi
      }
      ;;
    libmysqlclient.so.*)
      echo "Instalando MySQL client..."
      sudo apt install -y libmysqlclient-dev
      ;;
    libboost_*.so.*)
      echo "Instalando Boost..."
      sudo apt install -y libboost-all-dev
      ;;
    libssl.so.*)
      echo "Instalando OpenSSL..."
      sudo apt install -y libssl-dev
      ;;
    libcrypto.so.*)
      echo "Instalando libcrypto..."
      sudo apt install -y libssl-dev
      ;;
    *)
      PKG=$(apt-file search "$LIB" 2>/dev/null | head -n 1 | cut -d: -f1)
      if [ -n "$PKG" ]; then
        echo "Instalando pacote $PKG para $LIB"
        sudo apt install -y "$PKG"
      else
        echo "Pacote não encontrado automaticamente para $LIB"
      fi
      ;;
  esac
done

echo
echo "Atualizando cache de bibliotecas..."
sudo ldconfig

echo
echo "Verificação final:"
ldd "$BIN" | grep "not found" || echo "Todas as bibliotecas resolvidas."
