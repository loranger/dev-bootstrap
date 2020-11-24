#!/usr/bin/env sh

default_project_path="~/Developer/projects"

template_path="$(dirname $0)/templates/"

function available-templates-for () {
    templates=($(basename -a $template_path/$1/*/))
    # echo "${templates[@]}"
}

function slugify () {
    echo "$1" | iconv -t ascii//TRANSLIT | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-+|-+$//g' | tr A-Z a-z
}

function init-project-path () {
    if [ $# -ne 2 ]
    then
        echo "Missing parameter. Should be $0 <project_name> <parent_path>"
        return 0
    else
        cd $2
        rm -rf $1
    fi
}

function init-docker-for () {

    if [ $# -eq 0 ]
    then
        templates=($(basename -a $template_path*/))
        PS3="template: "
        select source in $templates;
        do
            break;
        done
    else
        source=$1
    fi

    template="${dockerforpath}${source}"
    if [ ! -d "${dockerforpath}${source}" ]; then
        echo "$source template does not exists"
        return 0
    else
        \cp -rf $template/. .
    fi

}

function init-project ()
{

    if [ $# -eq 0 ]
    then
        defaultprojectname="My Project"
        read "?Name of the new project? [$defaultprojectname] " projectname
        : ${projectname:=$defaultprojectname}
        # echo "you answered: $(slugify $projectname)"
    else
        projectname=$1
    fi

    read "?“$projectname” parent folder? [$default_project_path] " projectpath
    : ${projectpath:=$default_project_path}
    # echo "you answered: $projectpath"

    available-templates-for "init"
    PS3="What kind of project: "
    select type in $templates;
    do
        break;
    done

    # init-project-path `slugify $projectname` $projectpath

}
