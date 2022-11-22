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

