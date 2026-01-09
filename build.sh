#!/bin/bash

# Navega para o diretório src
cd "$(dirname "$0")/src" || exit 1

# Limpa compilações anteriores, se existiren
echo "Limpando compilações anteriores..."
make clean 2>/dev/null

# Executa o autogen.sh se existir
if [ -f "autogen.sh" ]; then
    echo "Executando autogen.sh..."
    ./autogen.sh
fi

# Executa o configure se existir
if [ -f "configure" ]; then
    echo "Configurando o projeto..."
    ./configure
fi

# Verifica se o Makefile foi gerado
if [ ! -f "Makefile" ]; then
    echo "Erro: Falha ao gerar o Makefile!"
    exit 1
fi

# Compila o projeto
NPROC=$(nproc)
echo "Iniciando a compilação usando $NPROC núcleos..."
make -j"$NPROC"

# Verifica se a compilação foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "\nCompilação concluída com sucesso!"
    echo "O executável foi criado em: $(pwd)/theforgottenserver"
    
    # Copia o executável para o diretório raiz
    cp theforgottenserver ..
    echo "O executável foi copiado para o diretório raiz do projeto."
else
    echo "\nErro durante a compilação! Verifique as mensagens de erro acima."
    exit 1
fi

# Torna o script executável
chmod +x "$0"
