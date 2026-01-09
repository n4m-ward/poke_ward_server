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