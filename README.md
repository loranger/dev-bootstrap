Setup a new project as simply as `init-project`

# Installation

Clone this repository and source the `functions.sh` from your `~.zshrc` or your `.aliases` :

```shell
source ~/Developer/projects/dev-bootstrap/functions.sh
```

You're ready to go.
You can also customize your [default projects path](https://github.com/loranger/dev-bootstrap/blob/main/functions.sh#L4) and/or your [favorite text editor](https://github.com/loranger/dev-bootstrap/blob/main/functions.sh#L3)

# Usage

### Full install

From anywhere using a terminal, you should now be able to call `init-project` :

- You will be prompted for the project name
- Then the script will ask for the path where the project should be stored
- You will then have to choose what kind of project you would like from [available templates](https://github.com/loranger/dev-bootstrap/tree/main/templates/init)
- Once your new project structure is ready, the script will ask for installing Docker files matching the kind of project you did bootstrap
- You wil also have to confirm if you want a deployer recipe
- Git will then init and commit the initial one
- Your favorite editor will now open the brend new project for you

Shorthand : You can also call the init-project with the project name and name arguments (`init-project Demo laravel`)

### Partial install

You can call separate parts of the init-project script on your will

`init-docker-for` will add the docker files to your existing folder once you choose the matching template. You can also init docker  specifying the type of the project you use : `init-docker-for laravel`

`init-git` will clean the submodules of the current project, and init versionning for the current folder

`init-deployer-for` will add recipes to your existing folder once you choose the matching template. You can also init deployer recipes specifying the type of the project you use : `init-deployer-for laravel`
