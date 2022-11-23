# SQLite-DBT-Example

This is an example [dbt](https://www.getdbt.com/) project, for [dbt-core](https://docs.getdbt.com/docs/get-started/getting-started-dbt-core) (refeerd to as the CLI/Community/Open Source edition)
of `dbt` (which can be used in any environment).

**Note** If you are new to dbt, this isn't a place to start. Go and read there great documentation (for this CLI, you want dbt core): https://docs.getdbt.com/docs/get-started/getting-started/overview

My intention is for this example (and anything built like it/extending on it) to be self-contained, so it can be replaced and deleted with minimal impact on the computer it's being run on.
I hope that it paves the way for self-contained demo projects, useful for tutorials and sharing solutions within the community.

This project is using the [dbt-SQLite](https://docs.getdbt.com/reference/warehouse-setups/sqlite-setup) database connector, with a local (to the project) `profiles.yml` configuration.

Using `SQLite` as a database is the lightest and most self-contained option.
Developers using dbt use a wide array of databases, and I wanted to create something anyone in the community could use for dbt demos (focusing on dbt rather than a specific database) with minimal overhead.

I was inspired by the recent changes to allow for a local (to the project) `profiles.yml` configuration file. 

This can have someone running a pre-built dbt project without installing any large database software, with everything self-contained in a python virtual environment and local directory structure (checked out from GitHub).

# 'Out of the box' Install & Execute

The instructions are the fastest way to checkout, install dependencies and run this project in your environment.

## General

### Prerequisites

How software is installed on your system is a personal choice and beyond this document (but as I intend this to be for tutorials I will give some pointers).
 
* If you use Linux, chances are you will already know the package manager on your distribution.
* If you use Mac OS, then the best way to get all the tools/applications required is [Homebrew](https://brew.sh/).
* If you use Windows, then you will have to download a few things from a few different websites and install/configure them.

You will need to have:

* Git - One can always download the project as a zip file and unzip it into the location, but I expect most people to already have git installed/available.
  * The standard version from https://git-scm.com/
  * The desktop application from GitHub https://desktop.github.com/
  * Embedded into another application/IDE (such as [Egit](https://www.eclipse.org/egit/) for [eclipse](https://www.eclipse.org/))
* python - https://www.python.org/
* SQLite - The `dbt-sqlite` package installs everything dbt needs for SQLite, but if you wish to view the database you will need either [SQLite](https://www.sqlite.org/download.html) or something which can browse the database file such as [DB Browser for SQLite](https://sqlitebrowser.org/dl/). 

### Overview of Steps

1. Create a working directory - so the code, python installation and database all site in a self-contained location.
1. Clone the code from git - This can be using:
   1. The usual git ssh integration/desktop application.
   1. Use `HTTPS` for a git pull if you haven't configured git ssh locally.
   1. If you aren't signed into a git account, download the code in a zip file and extract it.
1. Create a python virtual environment - Keeping all the libraries and dependencies nicely independent.
1. Start the virtual environment, and install `dbt-sqlite`
1. Run the project

## Setup Script
**Use this at your own peril!**

**You should start with the section: 'Step by step' Checkout & Execution**

I've only tested it on Mac and Linux (ubuntu). 

As a proof of concept, a script can be called to configure everything ready for a `dbt run`. The script in this repository is:
[git_demo_install.bash](install/git_demo_install.bash)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/d-roman-halliday/SQLite-DBT-Example/main/install/git_demo_install.bash)"
```

So all you need to do is
```
source venv/bin/activate

cd SQLite-DBT-Example
cd demo

dbt run
```


## 'Step by step' Checkout & Execution
These commands have been run/tested using Linux, Mac OS and Windows (both git bash and `cmd`). I've put comments for the variations.

```
# Create a working directory
mkdir dbt_demo
cd dbt_demo

# Clone the code from git (use one of)
git clone git@github.com:d-roman-halliday/SQLite-DBT-Example.git
git clone https://github.com/d-roman-halliday/SQLite-DBT-Example.git

# Create a python virtual environment (the second option shown as a Windows example, because python isn't always configured in the path on windows)
python -m venv venv
"C:\Program Files\Python310\python.exe" -m venv venv

# Start the virtual environment (The second line is for cmd under windows)...
source venv/bin/activate
venv\Scripts\activate.bat

# ...and install `dbt-sqlite`
pip install --upgrade pip
pip install dbt-SQLite

#Run the project (changing into directory, showing both options for run and build (which includes tests))
cd SQLite-DBT-Example
cd demo

dbt run

dbt build
```

## View models created

Now it's time to see the database created (the local SQLite database). This can be done on the command line:

    sqlite3 ../local_sqlite_project_db.sqlite

Or using an application to browse the database file such as [DB Browser for SQLite](https://sqlitebrowser.org/dl/). 


## SQLite commands & output
Testing the output by querying the database should look like the below:

```
SQLite version 3.37.0 2021-12-09 01:34:53
Enter ".help" for usage hints.
sqlite> .tables
my_first_dbt_model   my_second_dbt_model
sqlite> .headers on
sqlite> SELECT * FROM my_first_dbt_model;
id
1
2
sqlite> SELECT * FROM my_second_dbt_model;
id
1
sqlite> .mode line
sqlite> SELECT * FROM my_second_dbt_model;
id = 1
sqlite> 
```

# Installation & Configuration Command History

This is how I created and configured the project, if you wish to replicate my process for your own project, then these are the steps I took.

## Create a directory for this self-contained project

    mkdir demo_dbt_sqlite
    cd demo_dbt_sqlite

## Check out the empty repo
For setting up the project/repository it needs some configuration.

    git clone git@github.com:d-roman-halliday/SQLite-DBT-Example.git
    # Edit this file
    vi README.md

## Create & configure python venv (Virtual Environment)
This ensures that all we do is self-contained from a software installation and management perspective.
For the demonstration, we will stick with whatever default python version is on the system at hand.

    # From the 'demo_dbt_sqlite' directory (so the venv is independent of the codebase)
    python -m venv venv

    # Start the virtual environment
    source venv/bin/activate

    # Upgrade pip
    pip install --upgrade pip
    # Install 'dbt-sqlite', which depends on (so includes) 'dbt-core' and other libraries
    pip install dbt-sqlite

## Create demo project
This checks the dbt installation and creates the demo project (built into the dbt application).

    # Test dbt instalation
    dbt --version

    # Craete 'demo' project which includes the 'example' models
    dbt init demo

## Configure project & SQLite
See the dbt docs for [SQLite setup](https://docs.getdbt.com/reference/warehouse-setups/sqlite-setup).
Since more recent versions of dbt, the `profiles.yml` file doesn't need to be in the `~/.dbt` location, instead, it can be local to a project which is handy for this sort of standalone situation.

    # Modify the profiles
    vi demo/profiles.yml

### profiles.yml
Note there are changes from the original docs:

1. The configuration name has been changed to `local_sqlite_project`, this will need to be reflected in the `dbt_project.yml`.
1. The database file location has been given as `../local_sqlite_project_db.sqlite` this places the file outside of the rest of the dbt code but within the project filesystem, it will need to be removed from the code by the `.gitignore` file.
1. The `extensions` section is commented out (according to the docs this is required for crypto and snapshots). This will be enabled later.


```
local_sqlite_project:
  target: dev
  outputs:
    dev:
      type: sqlite
      threads: 1
      database: 'database'
      schema: 'main'
      schemas_and_paths:
        main: '../local_sqlite_project_db.sqlite'
      schema_directory: 'file_path'
      #optional fields
#     extensions:
#       - "/path/to/sqlean/crypto.so"
```

### dbt_project.yml
This change is to reflect the name in the above `profiles.yml`.

    # This setting configures which "profile" dbt uses for this project.
    profile: 'local_sqlite_project'

## Execution & Testing
Now it's time to test the Execution:

    dbt run

The project should run successfully, if it doesn't check the output for useful error messages (dbt is quite good with them).
Then try:

    dbt build

If you are familiar with the demo/example project there is a bug in one of the models which needs fixing.

    vi models/example/my_first_dbt_model.sql

Now it's time to see the database created (the local SQLite database).

    sqlite3 ../local_sqlite_project_db.sqlite

### SQLite commands & output
Testing the output by querying the database should look like the below:

```
SQLite version 3.37.0 2021-12-09 01:34:53
Enter ".help" for usage hints.
sqlite> .tables
my_first_dbt_model   my_second_dbt_model
sqlite> .headers on
sqlite> SELECT * FROM my_first_dbt_model;
id
1
2
sqlite> SELECT * FROM my_second_dbt_model;
id
1
sqlite> .mode line
sqlite> SELECT * FROM my_second_dbt_model;
id = 1
sqlite> 
```

# Future Changes & Additions

## SQLite Extensions & sqlean
The [sqlean](https://github.com/nalgeon/sqlean) project exists to add extensions to SQLite, as commented out in `profiles.yml`. 
Depending on the operating system, this will need to be installed.
If you are working from Mac OS, this is going to be hard work.
