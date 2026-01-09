#!/bin/bash

# Script para compilar o The Forgotten Server para Windows 32-bit usando o Makefile.win
# Autor: Assistente de IA

# Configurações
BUILD_DIR="build_win32_makefile"
OUTPUT_FILE="TheForgottenServer.exe"
MINGW_PREFIX="i686-w64-mingw32"

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verifica se estamos no Ubuntu/Debian
if ! command -v apt-get >/dev/null 2>&1; then
    echo "Erro: Este script é destinado a sistemas baseados em Ubuntu/Debian."
    exit 1
fi

# Verifica se o MinGW está instalado
if ! command_exists "${MINGW_PREFIX}-g++" || ! command_exists "${MINGW_PREFIX}-gcc"; then
    echo "Instalando o compilador MinGW para Windows..."
    sudo apt update
    sudo apt install -y gcc-mingw-w64-i686 g++-mingw-w64-i686 mingw-w64-tools
fi

# Instala dependências adicionais necessárias
sudo apt install -y \
    liblua5.1-0-dev \
    libmysqlclient-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-thread-dev \
    libssl-dev \
    zlib1g-dev \
    libxml2-dev \
    libpugixml-dev \
    libgmp-dev

# Cria o diretório de build se não existir
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Copia todos os arquivos fonte do diretório src para o diretório de build
echo "Copiando arquivos fonte..."
cp -r ../src/* .

# Copia o Makefile.win para o diretório de build
cp dev-cpp/Makefile.win .

# Cria o diretório obj se não existir
mkdir -p obj

# Configura as variáveis de ambiente para a compilação cruzada
export CC="${MINGW_PREFIX}-gcc"
export CXX="${MINGW_PREFIX}-g++"
export AR="${MINGW_PREFIX}-ar"
export RANLIB="${MINGW_PREFIX}-ranlib"
export WINDRES="${MINGW_PREFIX}-windres"

# Flags de compilação
export CFLAGS="-I/usr/${MINGW_PREFIX}/include -I/usr/local/include"
export CXXFLAGS="-I/usr/${MINGW_PREFIX}/include -I/usr/local/include -D__USE_MYSQL__ -D__USE_SQLITE__ -D__ENABLE_SERVER_DIAGNOSTIC__ -O2"
export LDFLAGS="-L/usr/${MINGW_PREFIX}/lib -L/usr/local/lib -static-libgcc -static-libstdc++ -static"

# Bibliotecas necessárias (ajuste conforme necessário)
LIBS="-lboost_system -lgmp -llua5.1 -lboost_regex -lsqlite3 -lws2_32 -lxml2 -lmysql -lboost_filesystem -lboost_thread -lssl -lcrypto -lz -lpugixml"

# Compilação usando o Makefile.win
echo "Iniciando a compilação..."
make -f Makefile.win \
    CPP="${CXX}" \
    CC="${CC}" \
    WINDRES="${WINDRES}" \
    CXXFLAGS="${CXXFLAGS}" \
    CFLAGS="${CFLAGS}" \
    LDFLAGS="${LDFLAGS}" \
    LIBS="${LIBS}" \
    -j$(nproc)

# Verifica se a compilação foi bem-sucedida
if [ $? -eq 0 ] && [ -f "$OUTPUT_FILE" ]; then
    # Copia o executável para o diretório raiz
    cp "$OUTPUT_FILE" ..
    echo "\nCompilação concluída com sucesso!"
    echo "O executável foi salvo como: $(pwd)/../$OUTPUT_FILE"
else
    echo "\nErro durante a compilação! Verifique as mensagens de erro acima."
    exit 1
fi

# Torna o script executável
chmod +x "$0"
