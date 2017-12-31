# Docker environment for AWDWR 5.1
Go through the AWDWR book without having to install anything locally (i.e., you can skip chapter 1).

## What you get
The equivalent of following the Linux instructions in Chapter 1. Namely:

* Ubuntu 16.04 LTS
* Ruby 2.4 via rvm + latest bundler and rails 5.1 gems
* Node 8.x, yarn
* Apt packages: libmysqlclient-dev mysql-client chromium-chromedriver

Additionally, it includes all the gems included in the default bundle (when you run `rails new <appname>`). This setup is very simple, and will likely be far too slow for everyday use on an actual, real-world Rails project (to fix that, see http://docker-sync.io/), but it is perfect for trying out the sample code in the AWDWR book.

## How to use

1. Install Docker for Mac, give it access to at least 2 CPUs and 2 GB RAM.
2. Clone this repo to your local machine and cd to the cloned dir
3. Run `docker-compose up`
4. Do stuff! (See "Running commands inside the container" below.)
5. When you're done, hit Ctrl-C (once) and the containers will shut down.
6. If you actually want to destroy the containers, run `docker-compose down`.

Using Docker is a bit like using Cloud9 (indeed, the original Cloud9 service referenced by the book used Docker containers internally), so when you see references to c9 in the book, they will often apply to this setup as well (for example, the web console fix on p.58).

## Running commands inside the container
1. In a separate terminal window, cd to the cloned dir
2. Run `docker-compose exec -u app web bash -l`  (protip: make a shell alias for this)
3. If you need a root shell: `docker-compose exec web bash -l`

## Differences vs. the book
This section is very incomplete (pull requests welcome).

* Rails 5.1.4 has been released, so we'll use that instead of 5.1.3. Other minor gem updates are also included.
* p.48: `bin/rails server -b 0.0.0.0` will not enable the server to be accessible from other machines on your network.

## Optional: MariaDB/MySQL
Although the book sticks with sqlite for the most part, it's easy to switch to MariaDB. (If you aren't familiar with MariaDB, it is a fork of MySQL that maintains compatibility, and even uses the same commands and file names.)

1. Uncomment the links: section (two lines) under services -> web
2. Uncomment the the db: section (four lines) at the bottom
3. Run `docker-compose up` as usual, and this time MariaDB will start.

Of course, you can use actual MySQL if you want. Just change the image line in docker-compose.yml:
    image: mariadb:10.2.11

to something like this:
    image: mysql:5.7.20

### Database management
Two helpful utilities are included to dump and load databases.

* to dump a database: `docker/bin/dump-db <database name>`
* to load a database backup: `docker/bin/load-db <database name> <dump filename>`
