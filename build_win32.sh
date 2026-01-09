#!/bin/bash

# Script para compilar o The Forgotten Server para Windows 32-bit no Ubuntu
# Autor: Assistente de IA

# Configurações
TARGET="i686-w64-mingw32"
BUILD_DIR="build_win32"
OUTPUT_FILE="theforgottenserver.exe"

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verifica se estamos no Ubuntu/Debian
if ! command -v apt-get >/dev/null 2>&1; then
    echo "Erro: Este script é destinado a sistemas baseados em Ubuntu/Debian."
    exit 1
fi

# Atualiza a lista de pacotes
echo "Atualizando lista de pacotes..."
sudo apt update

# Instala as dependências necessárias
echo "Instalando dependências..."
sudo apt install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    mingw-w64 \
    mingw-w64-tools \
    mingw-w64-i686-dev \
    mingw-w64-common \
    g++-mingw-w64-i686 \
    gcc-mingw-w64-base \
    gcc-mingw-w64-i686 \
    liblua5.1-0-dev:i386 \
    libmysqlclient-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-thread-dev \
    libssl-dev \
    zlib1g-dev \
    libxml2-dev \
    libpugixml-dev

# Verifica se o diretório src existe
if [ ! -d "src" ]; then
    echo "Erro: Diretório 'src' não encontrado!"
    exit 1
fi

# Cria o diretório de build se não existir
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Configuração para compilação cruzada
echo "Configurando para compilação cruzada Windows 32-bit..."
../src/configure \
    --host=$TARGET \
    --enable-mysql \
    --with-lua-version=5.1 \
    --with-boost-system=boost_system-mt \
    --with-boost-filesystem=boost_filesystem-mt \
    --with-boost-thread=boost_thread-mt \
    --with-boost-regex=boost_regex-mt \
    CXXFLAGS="-std=c++11 -static-libgcc -static-libstdc++ -D_WIN32_WINNT=0x0501 -D__USE_MINGW_ANSI_STDIO=0 -static" \
    LDFLAGS="-static-libgcc -static-libstdc++ -static"

# Compilação
echo "Iniciando a compilação..."
make -j$(nproc)

# Verifica se a compilação foi bem-sucedida
if [ $? -eq 0 ]; then
    # Copia o executável para o diretório raiz
    if [ -f "$OUTPUT_FILE" ]; then
        cp "$OUTPUT_FILE" ..
        echo "\nCompilação concluída com sucesso!"
        echo "O executável foi salvo como: $(pwd)/../$OUTPUT_FILE"
    else
        echo "Erro: O arquivo de saída não foi encontrado."
        exit 1
    fi
else
    echo "\nErro durante a compilação! Verifique as mensagens de erro acima."
    exit 1
fi

# Torna o script executável
chmod +x "$0"
