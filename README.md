# Passo a passo execução:

### Instalar as libs necessarias para a execução do tfs:

```sh
./install_libs_rfs.sh
```

```sh
sudo apt install libboost-regex1.74.0
```

---

### Instalar mariadb ou mysql

---
### Importar o banco de dados:

```sh
mysql -u root -p pokemysterious < mysterious.sql
```

#### Ou caso esteja usando mariadb

```sh
mariadb -u root -p pokemysterious < mysterious.sql
```

---

## Inicializar o servidor:

### Inicializar em primeiro plano:

```shell
./theforgottenserver
```

### Inicializar em segundo plano

```shell
./start-tfs.sh
```

### Parar o servidor que está em segundo plano:

```shell
./stop-tfs.sh
```

### Reiniciar servidor mantendo ele em segundo plano:

```shell
./restart-tfs.sh
```

---

# Inicializar tfs manualmente com cpulimit e memory limit

### Primeiro de tudo, precisamos instalar as libs necessarias

```shell
sudo apt install cpulimit -y
```

```shell
sudo apt install cpulimit -y
```

### Definir limite de memoria ram á 1.2gb
```shell
ulimit -v 1258291
```

### Executar tfs com limite de cpu 50%

```shell
cpulimit -l 50 ./theforgottenserver
```