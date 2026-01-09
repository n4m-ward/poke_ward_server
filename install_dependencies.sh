#!/bin/bash

# Atualiza a lista de pacotes
echo "Atualizando lista de pacotes..."
sudo apt update

# Instala as dependências necessárias
echo "Instalando dependências..."
sudo apt install -y \
    build-essential \
    cmake \
    liblua5.1-0-dev \
    libgmp3-dev \
    libmysqlclient-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-thread-dev \
    libssl-dev \
    libcrypto++-dev \
    libpugixml-dev \
    zlib1g-dev \
    libxml2-dev \
    libboost-regex-dev \
    libgmp-dev \
    libboost-iostreams-dev \
    liblua5.1-0

# Verifica se o diretório src existe
if [ ! -d "src" ]; then
    echo "Erro: Diretório 'src' não encontrado!"
    exit 1
fi

echo "Todas as dependências foram instaladas com sucesso!"
echo "Execute o script build.sh para compilar o servidor."

# Torna o script executável
chmod +x "$0"
