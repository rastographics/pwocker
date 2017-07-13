# Pwocker: Processwire in Docker

Here are the advantages of this processwire/docker combo

## For Windows Developers
I'm using this on a Windows 10 Pro 64-bit machine. So I know it works on that.

## Local Debugging!
Xdebug works with this setup. Included a working VS Code debug config under .vscode/launch.json

## Easy configuration for developing multiple apps simultaneously 
- Uses a separate "shared" Nginx Proxy container that runs all the time, and automatically routes requests to correct Processwire app based on the hostname in URL.
- Each app has it's own PHP and MySql(MariaDb) containers

## Simple configuration
1. Start the Nginx Proxy globally with one command (or just double-click the `proxy-up.cmd` file!). This needs to be done only once for all apps.
2. Copy the `docker-compose.yml`, `Dockerfile-php`, and `get-processwire.ps1` files into your project directory. (Repeat this step for each separate project).
3. Set `VIRTUAL_HOST` and `docker_hostip` variables in the `docker-compose.yml` file.
  - `VIRTUAL_HOST` = `myappname.localtest.me` (or whateveryouwant.localtest.me)
  - `docker_hostip` = Local IP address of your Physical Host Machine
4. Run `docker-compose up -d`.
5. A `src` directory will be created.
6. Right-click on `get-processwire.ps1` and Run with Powershell. This copies latest dev version of Processwire AND the new Foundation 6 site profile right to the src folder.
7. In a browser, visit `myappname.localtest.me` (or whateveryouwant.localtest.me) and enjoy the Processwire Setup wizard!




# Structure

### Nginx Proxy

A single Nginx Proxy app handles all requests to localhost (port 80) for all your processwire apps you will be developing. 

**Instructions**
Run the Nginx Proxy by running `proxy-up.cmd`. The Nginx Proxy must be running in order for everything else to work. Confirm it is running by typing `docker ps` in a terminal.

By using a DNS->localhost service like `localtest.me`, multiple apps can be assigned unique hostnames that route back to localhost (127.0.0.1) **WITHOUT** the need to touch the *hosts* file. (Especially on Windows, editing the hosts file is a pain, and wildcards cannot be used for subdomains.)

So in the `docker-compose.yml` for each app, simply assign the VIRTUAL_HOST env variable with `app1.localtest.me` or `app2.localtest.me`, etc and Nginx Proxy will route those requests to the proper app. Like magic :)


### Each PW App

For each processwire app you are developing, copy this `docker-compose.yml` file into the app's root folder. 

Upon running `docker-compose up -d` from the root folder, a `src` folder will be created if it doesn't already exist. 
`src` is the public root of your processwire app. Copy your processwire files here.

Don't forget to change `site/config.php` to point to correct database/user/password (and add the right host).

The database name, user, and password are found in your app's `docker-compose.yml`.

The database server name (hostname) is simply `db`.


# TODO

**MySql Data Import**
I need to create a subfolder `mysql` where a `database.sql` file with PW database dump can be saved. Then have a script somewhere that will import that file into the database if the database is empty when starting the container.

OR...if there is NO database and `./src/site/assets/backups/database` has `.sql` files, get the most recent sql file and import it.