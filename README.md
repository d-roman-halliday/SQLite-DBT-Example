# SQLite-DBT-Example
An example project using dbt-SQLite with local configuration

# Command History

## Craete a directory for this self contained project

    mkdir demo_dbt_sqlite
    cd demo_dbt_sqlite

## Check out the empty repo
For the purpose of working with setting up this example project/repository it needs some configuration

    git clone git@github.com:d-roman-halliday/SQLite-DBT-Example.git
    # Edit this file
    vi README.md

## Craete & Configure python venv (Virtual Environment)
This ensures that all we do is self contained from a software installation and management perspective.
For thepurpose of the demonstration we will stick with whatever default pythong version is on the systemat hand.

    # From the 'demo_dbt_sqlite' directory (so the venv is independent of the codebase)
    python -m venv venv

    # Start the virtual environment
    source venv/bin/activate

    # Upgrade pip
    pip install --upgrade pip
    # Install 'dbt-sqlite', includes 'dbt-core' and other libraries
    pip install dbt-sqlite

## Create demo project
This checks the dbt instalation and creates the demo project (built in to the dbt application)

    # Test dbt instalation
    dbt --version

    # Craete 'demo' project which includes the 'example' models
    dbt init demo

## configure project & SQLite
See the dbt docs for [SQLite setup](https://docs.getdbt.com/reference/warehouse-setups/sqlite-setup).
Since more recent versions of dbt, the `profiles.yml` file doesn't need to be in the `~/.dbt` location, instead it can be local to a project which is handy for this sort of standalone situation.

    # Modify the profiles
    vi demo/profiles.yml

### profiles.yml
Note there are changes from the original docs:
1. The configuration name has been changed to `local_sqlite_project`, this will need to be relected in the `dbt_project.yml`.
1. The database file location has been given as `../local_sqlite_project_db.sqlite` this places the file outside of the rest of the dbt code but within the project filesystem, it will need to be removed from the code by the `.gitignore` file.
1. the `extensions` section is commented out (according to the docs this is required for crypto and snapshots). This will be enabled later.

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

### dbt_project.yml
This change is to reflect the name in the above `profiles.yml`

    # This setting configures which "profile" dbt uses for this project.
    profile: 'local_sqlite_project'

## Execution & Testing
Now it's time to test the Execution

    dbt run

The project should run succesfully, if it doesn't check the output for useful error mesages (dbt is quite good with them).
Then try:

    dbt build

If you are familiar with the demo/example project there is a bug in one of the models which needs fixing

    vi models/example/my_first_dbt_model.sql

Now it's time to see the database craeted (the local SQLite database)

    sqlite3 ../local_sqlite_project_db.sqlite

### SQLite Commands & output
Testing the output by querying the database should look like the below:

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

