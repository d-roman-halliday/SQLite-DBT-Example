#/bin/bash

check_venv_is_running(){
    if [[ "$VIRTUAL_ENV" != "" ]]
    then
        #venvrunning
        VENV_IS_RUNNING=1
    elif [ -n "${PIPENV_ACTIVE}" ] && [ "${PIPENV_ACTIVE}" -eq 1  ]
    then
        #pipenv running
        VENV_IS_RUNNING=1
    else
        #Assume no virtual environment running
        VENV_IS_RUNNING=0
    fi

}

check_venv_dir_exists(){
    # Lazy way to get first instance of activate file found (looking in this directory)
    activate_script_location=`find . -type f -name 'activate' | head -n 1`
  
    # Lazy way to get first instance of activate file found (looking in the parent directory)
    if [[ -f "${activate_script_location}" ]]
    then
        VENV_DIR_EXISTS=1
    else
        VENV_DIR_EXISTS=0
    fi

}

################################################################################
# Check required software
################################################################################

which python3

if [ $? -ne 0 ]
then
    echo "python not installed"
    exit 1  
fi

which git

if [ $? -ne 0 ]
then
    echo "git not installed"
    exit 2  
fi


################################################################################
# Clone and setup
################################################################################

#mkdir dbt_demo
#cd dbt_demo

# Clone the code from git (use https)
git clone https://github.com/d-roman-halliday/SQLite-DBT-Example.git

# If a virtual environment is detecrted, don't try and craete it, just continue
check_venv_is_running
check_venv_dir_exists

if [[ ${VENV_IS_RUNNING} -eq 0 ]]
then
    if [[ ${VENV_DIR_EXISTS} -eq 0 ]]
    then
        # Create a python virtual environment (the second option shown as a Windows example, because python isn't always configured in the path on windows)
        python -m venv venv
    fi

    # Start the virtual environment (The second line is for cmd under windows)...
    source venv/bin/activate
fi

# ...and install `dbt-sqlite`
pip install --upgrade pip
pip install dbt-SQLite

# If a virtual environment isn't running, prompt to start one
if [[ ${VENV_IS_RUNNING} -eq 0 ]]
then
    echo "You may need to start the virtual environment with the command:"
    echo "source venv/bin/activate"
fi
