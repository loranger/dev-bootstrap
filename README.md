Setup a new web (PHP) project as simply as `init-project`

# Installation

Clone this repository and source the `functions.sh` from your `~.zshrc` or your `.aliases` :

```shell
source <path of the cloned dev-bootstrap>/functions.sh
```

You're ready to go.
You can also customize your [default projects path](https://github.com/loranger/dev-bootstrap/blob/main/functions.sh#L4) and/or your [favorite text editor](https://github.com/loranger/dev-bootstrap/blob/main/functions.sh#L3)

# Usage

### Full init

From anywhere using a terminal, you should now be able to call
```bash
init-project
```

This command will drive you through the following steps:

1. You will be prompted for the project name
2. Then the script will ask for the local path where your project should be stored
3. You will then have to choose what kind of project you would like from [available templates](https://github.com/loranger/dev-bootstrap/tree/main/templates/init)
4. Once your new project structure is ready, the script will prompt for installing [Docker files](https://github.com/loranger/dev-bootstrap/tree/main/templates/docker) matching the kind of project you did create
5. You will also have to confirm if you want a [deployer](https://deployer.org/) recipe or not
6. You may choose if you want to init a remote rc file
7. Git will then init and commit the initial one
8. Your favorite editor will now open the brand new project for you

Shorthand : You can also call the init-project with the project name and name arguments

```bash
init-project MyDemo laravel
```



### Partial init

You can call separate parts of the init-project script on your will

##### Docker

```bash
init-docker-for
```
will add the docker files to your existing folder once you choose the matching template. 

You can also init docker specifying the type of the project you use : 
```bash
init-docker-for laravel
```

##### Git

```bash
init-git
```
will clean the submodules of the current project, and init versionning for the current folder

##### Deployer

```bash
init-deployer-for
```
will add recipes to your existing folder once you choose the matching template. 

You can also init deployer recipes specifying the type of the project you use : 
```bash
init-deployer-for laravel
```

# Custom

You can set your own preferences for your editor or the default project parent path by adding a `~/.dev-bootstrap.conf` file containing variables, like these:

```bash
editor=$VISUAL
default_project_path="~/Projects"
```