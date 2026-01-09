#!/bin/bash

BIN="./theforgottenserver"

if [ ! -f "$BIN" ]; then
  echo "Erro: binário $BIN não encontrado"
  exit 1
fi

echo "Analisando dependências com ldd..."
MISSING_LIBS=$(ldd "$BIN" | grep "not found" | awk '{print $1}')

if [ -z "$MISSING_LIBS" ]; then
  echo "Nenhuma biblioteca faltando."
  exit 0
fi

echo "Bibliotecas faltando:"
echo "$MISSING_LIBS"
echo

declare -A LIB_PACKAGE_MAP=(
  ["liblua5.1.so.0"]="liblua5.1-0"
  ["libmariadb.so.3"]="libmariadb3"
  ["libmysqlclient.so.21"]="libmysqlclient21"
  ["libboost_system.so.1.74.0"]="libboost-system1.74.0"
  ["libboost_filesystem.so.1.74.0"]="libboost-filesystem1.74.0"
  ["libboost_thread.so.1.74.0"]="libboost-thread1.74.0"
  ["libssl.so.1.1"]="libssl1.1"
  ["libcrypto.so.1.1"]="libssl1.1"
  ["libstdc++.so.6"]="libstdc++6"
  ["libgcc_s.so.1"]="libgcc-s1"
  ["libz.so.1"]="zlib1g"
)

PACKAGES_TO_INSTALL=()

for LIB in $MISSING_LIBS; do
  PKG="${LIB_PACKAGE_MAP[$LIB]}"
  if [ -n "$PKG" ]; then
    PACKAGES_TO_INSTALL+=("$PKG")
  else
    echo "Aviso: não sei qual pacote fornece $LIB"
  fi
done

if [ ${#PACKAGES_TO_INSTALL[@]} -eq 0 ]; then
  echo "Nenhum pacote conhecido para instalar automaticamente."
  exit 1
fi

echo
echo "Instalando pacotes necessários:"
echo "${PACKAGES_TO_INSTALL[@]}"
echo

apt update
apt install -y "${PACKAGES_TO_INSTALL[@]}"

echo
echo "Revalidando dependências..."
ldd "$BIN" | grep "not found" || echo "Todas as dependências resolvidas."
