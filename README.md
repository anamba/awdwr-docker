# Docker environment for AWDWR 5.1
Go through the AWDWR book without having to install anything locally (i.e., you can skip chapter 1).

## What you get
The equivalent of following the Linux instructions in Chapter 1. Namely:

* Ubuntu 16.04 LTS
* Ruby 2.4 via rvm + latest bundler and rails 5.1 gems
* Node 8.x, yarn
* Apt packages: libmysqlclient-dev mysql-client chromium-chromedriver

## How to use

1. Install Docker for Mac, give it access to at least 2 CPUs and 2 GB RAM.
2. Clone this repo to your local machine and cd to the cloned dir
3. Run `docker-compose up`
4. When you're done, hit Ctrl-C (once) and the containers will shut down.
5. If you actually want to destroy the containers, run `docker-compose down`.

## Running commands inside the container
1. In a separate terminal window, cd to the cloned dir
2. Run `docker-compose exec -u app web bash -l`  (protip: make a shell alias for this)
3. If you need a root shell: `docker-compose exec web bash -l`

## Optional: MariaDB
Although the book uses sqlite for the most part, if you want to use MariaDB, it's easy to enable.

1. Uncomment the links: section (two lines) under services -> web
2. Uncomment the the db: section (four lines) at the bottom
3. `docker-compose up`

### Database management
Two helpful utilities are included to dump and load databases.

* to dump a database: `docker/bin/dump-db <database name>`
* to load a database backup: `docker/bin/load-db <database name> <dump filename>`
