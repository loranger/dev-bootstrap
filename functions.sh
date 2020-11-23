#!/usr/bin/env sh

template_path="$(dirname $0)/template/"
default_project_path="~/Developer/projects"

function available-templates () {
    templates=($(basename -a $template_path*/))
    return $templates
}

function slugify () {
    echo "$1" | iconv -t ascii//TRANSLIT | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-+|-+$//g' | tr A-Z a-z
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

read "?Where is the “$projectname” parent folder? [$defaultprojectpath] " projectpath
: ${projectpath:=$defaultprojectpath}
echo "you answered: $projectpath"
}
