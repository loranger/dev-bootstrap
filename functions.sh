#!/usr/bin/env sh

editor=$VISUAL
default_project_path="~/Projects"

if [ -f ~/.dev-bootstrap.conf ]; then
    source ~/.dev-bootstrap.conf
fi

template_path="$(dirname $0)/templates"

function checkRequirement () {
    if ! which $1 > /dev/null; then
        echo "$1 command does not exist."
        return 1
    fi
    return 0;
}

# replaceInFile(File, From, To)
function replaceInFile() {
    FILE=$1
    FROM=$2
    TO=$3
    sed -i.tmp -e "s/$FROM/$TO/g" $FILE
    rm -f $FILE.tmp
}

# setVar(File, Variable, Value, After?)
function setVar() {
    FILE=$1
    VARIABLE=$2
    VALUE=$3
    AFTER=${4}

    if grep -q "${VARIABLE}=" $FILE; then # Replace value
        sed -i.tmp -e "s/$VARIABLE=.*/$VARIABLE=$VALUE/g" $FILE
    else # Append variable
        if [ -z "$AFTER" ]; then # to last line
            echo "$VARIABLE=$VALUE" >> $FILE
        else # after $AFTER
            sed -i.tmp -e "/^$AFTER=.*/a\\
$VARIABLE=$VALUE" $FILE
        fi
    fi
    rm -f $FILE.tmp
}

# setVar(File, Variable, Value)
function setVarIfExists() {
    FILE=$1
    VARIABLE=$2
    VALUE=$3

    if grep -q "${VARIABLE}=" $FILE; then # Replace value
        sed -i.tmp -e "s/$VARIABLE=.*/$VARIABLE=$VALUE/g" $FILE
    fi
    rm -f $FILE.tmp
}

function slugify () {
    echo "$1" | iconv -t ascii//TRANSLIT | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-+|-+$//g' | tr A-Z a-z
}

function available-templates-for () {
    templates=($(basename -a $template_path/$1/*/))
}

function init-project-path () {
    if [ $# -ne 2 ]
    then
        echo "Missing parameter. Should be $0 <project_name> <parent_path>"
        return 0
    else
        cd ${~2}
        rm -rf "$1"
    fi
}

function init-project-structure-for () {
    source ${template_path}/init/$1/init.sh "$projectname"
}

function init-docker-for () {
    if [ $# -eq 0 ]
    then
        available-templates-for "docker"
        PS3="Select you docker template: "
        select type in $templates;
        do
            break;
        done
    else
        type=$1
    fi

    template=${template_path}/docker/${type}

    if [ ! -d "${template}" ]; then
        echo "$source template does not exists"
        return 0
    else
        \cp -rf $template/. .
    fi

    if [ -z ${projectname} ]; then
        projectname=$(basename "`pwd`")
    fi

    for envfile in .env .env.example
    do
        if [ -f $envfile ]; then
            setVar $envfile 'APP_NAME' "\"$projectname\""
            setVar $envfile 'APP_PROJECT' `slugify $projectname` 'APP_NAME'
            setVar $envfile 'APP_URL' '"http:\/\/${APP_DOMAIN}"'
            setVar $envfile 'APP_DOMAIN' "`slugify $projectname`.docker" 'APP_PROJECT'

            setVar $envfile 'VITE_URL' '"vite.${APP_DOMAIN}"'
            setVar $envfile 'VITE_PORT' '3456'
            setVar $envfile 'VITE_WEBSOCKET_URL' '"http:\/\/websocket.${APP_DOMAIN}/"'
            setVar $envfile 'WEBSOCKET_URL' '"websocket.${APP_DOMAIN}"'

            setVarIfExists $envfile 'DB_HOST' '"${APP_PROJECT}-mariadb"'
            setVarIfExists $envfile 'DB_DATABASE' `slugify $projectname`
            setVarIfExists $envfile 'DB_USERNAME' 'app_user'
            setVarIfExists $envfile 'DB_PASSWORD' 'secret'

            setVarIfExists $envfile 'MEMCACHED_HOST' '"${APP_PROJECT}-memcached"'

            setVarIfExists $envfile 'REDIS_HOST' '"${APP_PROJECT}-redis"'

            setVarIfExists $envfile 'MAIL_HOST' '"${APP_PROJECT}-maildev"'
            setVarIfExists $envfile 'MAIL_FROM_ADDRESS' '"mailer@${APP_DOMAIN}"'
        fi
    done

    if [ ! -f .env ]; then
        cp .env.example .env
    fi

    if [ ! -f docker-compose.yaml -a ! -f docker-compose.yml ]; then
        cp docker-compose.example docker-compose.yml
    fi

    if [ -f README.md ]; then
        replaceInFile README.md 'project' `slugify $projectname`
    fi

}

function init-deployer-for () {
    if [ $# -eq 0 ]
    then
        available-templates-for "deployer"
        PS3="Select you deployer template: "
        select type in $templates;
        do
            break;
        done
    else
        type=$1
    fi

    template=${template_path}/deployer/${type}

    if [ ! -d "${template}" ]; then
        echo "$source template does not exists"
        return 0
    else
        \cp -rf $template/. .
    fi

    if [ -z ${projectname} ]; then
        projectname=$(basename `pwd`)
    fi
}

function init-remote-for () {

    if ! command -v remote &> /dev/null
    then
        echo "remote could not be found"
        echo "please install from https://github.com/loading-sasu/remote"
        exit
    else
        remote init
    fi
}

function init-git () {
    if [[ $(realpath $PWD) -ef $(realpath $(eval "$projectpath/`slugify $projectname`")) ]]
    then
        # Remove remaining git repositories installed from .dependencies
        find . -type d -mindepth 2 -name .git | xargs rm -rf \{\};

        git init
        git add .gitignore
        git add .

        if [ -z ${projectname} ]; then
            projectname=$(basename `pwd`)
        fi
        git commit -m ":tada: $projectname initial commit"
    else
        echo "Error with "$projectpath/`slugify $projectname`" path"
    fi
}

function init-editor () {
    if [ ! -z "$editor" ]; then
        $editor . &
    fi
}

function init-project ()
{
    if [ $# -eq 0 ]
    then
        defaultprojectname="My Project"
        read "?Name of the new project? [$defaultprojectname] " projectname
        : ${projectname:=$defaultprojectname}
    else
        projectname=$1
    fi

    read "?“$projectname” parent folder? [$default_project_path] " projectpath
    : ${projectpath:=$default_project_path}

    if [ $# -ne 2 ]
    then
        available-templates-for "init"
        PS3="What kind of project: "
        select type in $templates;
        do
            break;
        done
    else
        type=$2
    fi

    init-project-path `slugify $projectname` $projectpath
    
    (init-project-structure-for $type) || return $?
    # Make sure we're inside the project folder
    cd `slugify $1`
    
    read "?Do you need docker? [yN] " reply
    if [[ $reply =~ ^[Yy]$ ]]
    then
        init-docker-for $type
    fi
    read "?Do you need deployer? [yN]" reply
    if [[ $reply =~ ^[Yy]$ ]]
    then
        init-deployer-for $type
    fi
    read "?Do you need remote? [yN]" reply
    if [[ $reply =~ ^[Yy]$ ]]
    then
        init-remote-for $type
    fi
    init-git
    init-editor
}

(checkRequirement "iconv") || return $?
(checkRequirement "sed") || return $?
(checkRequirement "tr") || return $?