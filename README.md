# Pwocker: Processwire in Docker

Here are the advantages of this processwire/docker combo

## For Windows Developers
I'm using this on a Windows 10 Pro 64-bit machine. So I know it works on that.

## Flexible stack
- Uses a separate "shared" Nginx Proxy container that runs all the time, and automatically routes requests to correct Processwire app based on the hostname in URL.
- Each app has it's own PHP and MySql(MariaDb) containers

## Simple configuration
1. Start the Nginx Proxy globally with one command (or just double-click the `proxy-up.cmd` file!)
2. Copy the `docker-compose.yml` file into each processwire project you want to run. (Should be one level above the directory that contains `index.php`, `site`, and `wire` directories).
3. Set `VIRTUAL_HOST` variable in the `docker-compose.yml` file.
3. Update `site/config.php` with correct database and hostname info.
4. Run `docker-compose up -d`.



# Structure

### Nginx Proxy

A single Nginx Proxy app handles all requests to localhost (port 80) for all your processwire apps you will be developing. 

**Instructions**
Run the Nginx Proxy by running `proxy-up.cmd`. The Nginx Proxy must be running in order for everything else to work. Confirm it is running by typing `docker ps` in a terminal.

By using a DNS->localhost service like `localtest.me`, multiple apps can be assigned unique hostnames that route back to localhost (127.0.0.1) **WITHOUT** the need to touch the *hosts* file. (Especially on Windows, editing the hosts file is a pain, and wildcards cannot be used for subdomains.)

So in the `docker-compose.yml` for each app, simply assign the VIRTUAL_HOST env variable with `app1.localtest.me` or `app2.localtest.me`, etc and Nginx Proxy will route those requests to the proper app. Like magic :)


### Each PW App

For each processwire app you are developing, copy this `docker-compose.yml` file into the app's root folder. Create a `src` folder in the root folder. `src` is the public root of your processwire app. Copy your processwire files here.

Don't forget to change `site/config.php` to point to correct database/user/password (and add the right host).

Upon running `docker-compose up -d` from the root folder, a `src` folder will be created if it doesn't already exist. 


# TODO

**MySql Data Import**
I need to create a subfolder `mysql` where a `database.sql` file with PW database dump can be saved. Then have a script somewhere that will import that file into the database if the database is empty when starting the container.

OR...if there is NO database and `./src/site/assets/backups/database` has `.sql` files, get the most recent sql file and import it.