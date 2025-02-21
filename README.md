# AdminerNeo

## What is AdminerNeo?

AdminerNeo is a fork of Adminer, but it's better maintained and has more features. It's a full-featured database management tool written in PHP. Conversely, to phpMyAdmin, it consists of a single file ready to deploy to the target server. Adminer is available for MySQL, MariaDB, PostgreSQL, SQLite, MS SQL, Oracle, Elasticsearch and MongoDB.

> [AdminerNeo](https://github.com/adminerneo/adminerneo)

## How to use this image

### Standalone

```console
$ docker run --link some_database:db -p 8080:8080 ghcr.io/tomas-kulhanek/adminerneo-docker:latest
```

Then you can hit `http://localhost:8080` or `http://host-ip:8080` in your browser.

### ... via [`docker-compose`](https://github.com/docker/compose) or [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/)

Example `docker-compose.yml` for `adminerneo`:

```yaml
# Use root/example as user/password credentials

services:
  adminer:
    image: ghcr.io/tomas-kulhanek/adminerneo-docker:latest
    restart: always
    ports:
      - 8080:8080
  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
```

### Loading plugins

This image bundles all official AdminerNeo plugins. You can find the list of plugins on GitHub: https://github.com/adminerneo/adminerneo/tree/main/plugins.

To load plugins you can pass a list of filenames in `ADMINER_PLUGINS`:

```console
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_PLUGINS='tables-filter tinymce' ghcr.io/tomas-kulhanek/adminerneo-docker:latest
```

If a plugin *requires* parameters to work correctly instead of adding the plugin to `ADMINER_PLUGINS`, you need to add a custom file to the container:

```console
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_PLUGINS='login-servers' ghcr.io/tomas-kulahnek/adminerneo-docker:latest
Unable to load plugin file "login-servers", because it has required parameters: servers
Create a file "/var/www/html/plugins-custom/login-servers.php" with the following contents to load the plugin:

<?php
require_once('plugins/login-servers.php');

/** Set supported servers
    * @param array array($domain) or array($domain => $description) or array($category => array())
    * @param string
    */
return new AdminerLoginServers(
    $servers = ???,
    $driver = 'server'
);
```

To load a custom plugin you can add PHP scripts that return the instance of the plugin object to `/var/www/html/plugins-custom/`.

### Choosing a design

The image bundles all the designs that are available in the Adminer source package. You can find the list of designs on GitHub: https://github.com/adminerneo/adminerneo/tree/main/designs.

To use a bundled design you can pass its name in `ADMINER_DESIGN`:

```console
$ docker run --link some_database:db -p 8080:8080 -e ADMINER_DESIGN='nette' ghcr.io/tomas-kulhanek/adminerneo-docker:latest
```

To use a custom design you can add a file called `/var/www/html/adminer.css`.

### Usage with external server

You can specify the default host with the `ADMINER_DEFAULT_SERVER` environment variable. This is useful if you are connecting to an external server or a docker container named something other than the default `db`.

```console
docker run -p 8080:8080 -e ADMINER_DEFAULT_SERVER=mysql ghcr.io/tomas-kulhanek/adminerneo-docker:latest
```

### Setting default login credentials

You can set the following environment variables to configure the login screen:

| Environment Variable | Description |
| -------------------- | ----------- |
| `ADMINER_DEFAULT_DRIVER` | default connection driver | 
| `ADMINER_DEFAULT_SERVER` | default connection host |
| `ADMINER_DEFAULT_USER` | default connection user |
| `ADMINER_DEFAULT_PASSWORD` | default connection password |
| `ADMINER_DEFAULT_DB` | default connection database |

The supported driver values are:

| Value | Driver |
| ----- | ------ |
| `server` | MySQL |
| `sqlite` | SQLite 3 |
| `sqlite2` | SQLite 2 |
| `pgsql` | PostgreSQL |
| `oracle` | Oracle (beta) |
| `mssql` | MS SQL (beta) |
| `mongo` | MongoDB (beta) |
| `elastic` | Elasticsearch (beta) |

## Supported Drivers

While Adminer supports a wide range of database drivers this image only supports the following out of the box:

-	MySQL
-	PostgreSQL
-	SQLite
-	Elasticsearch

# License

View [license information](https://github.com/adminerneo/adminerneo/blob/main/LICENSE) for the software contained in this image.
