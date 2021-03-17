#!/usr/bin/env sh

editor="subl"
default_project_path="~/Developer/projects"

template_path="$(dirname $0)/templates"


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
        projectname=$(basename `pwd`)
    fi

    for envfile in .env .env.example
    do
        if [ -f $envfile ]; then
            if grep -q "APP_PROJECT=" $envfile; then
                sed -i.tmp -e "s/project/`slugify $projectname`/g" $envfile
            else
                sed -i.tmp -e "/^APP_URL=.*/a\\
APP_PROJECT=`slugify $projectname`" $envfile
            fi
            sed -i.tmp -e "s/APP_NAME=.*/APP_NAME=\"$projectname\"/g" $envfile
            sed -i.tmp -e "s/DB_DATABASE=.*/DB_DATABASE=`slugify $projectname`/g" $envfile
            rm -f $envfile.tmp
        fi
    done
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

function init-git () {
    # Remove remaining git repositories installed from .dependencies
    find . -type d -mindepth 2 -name .git | xargs rm -rf \{\};

    git init
    git add .gitignore
    git add .

    if [ -z ${projectname} ]; then
        projectname=$(basename `pwd`)
    fi
    git commit -m ":tada: $projectname initial commit"
}

function init-editor () {
    `$editor .`
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
    init-project-structure-for $type
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
    init-git
    init-editor
}
