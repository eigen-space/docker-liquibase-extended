# About

This solution extends base liquibase image and allow to fetch a config from external repository.

# Extended cli parameters

## configUrl

It is url to project with a configuration, that can be loaded with git. The project may inherit
defined structure to make liquibase options configuration simpler.

Be careful, if this parameter is defined extended configuration will be used.

The url should contain credentials to access to repository for fetching. Read permissions will be
enough. Example of this: `https://{USERNAME}:{TOKEN}@PATH_TO_REPOSITORY.git`

### The suggested structure of project with configuration

```
    <root>
        /migration-config
            /changelog
                0--changeset.sql
                main.xml
            liquibase.docker.properties
```

## configBranch (optional)

This is used to define a branch where target config is stored. By default, it's `master` branch.

## migrationConfigPath (optional)

This is used to define a path to migration config. By default, it's `/migration-config` folder.

# Usage

1. Create a config folder with migration scripts and push it to remote repository.

2. Run docker-liquibase-extended container with options and command:
    ```
    docker run --rm docker-liquibase-extended \
        --configUrl=https://{USERNAME}:{TOKEN}@PATH_TO_REPOSITORY.git \
        --configBranch=feature/1-do-something \
        --migrationConfigPath=database/migration-config \
        --url=jdbc:postgresql://{HOST}:{PORT}/{DATABASE} \
        --username={DATABASE_USERNAME} \
        --password={DATABASE_PASSWORD} \
        {COMMAND} # like `update`
    ```
   
5. Check your database. Profit.`

# Linter

It's highly recommended to validate your changes by running this command:\
`docker run --rm -i hadolint/hadolint < Dockerfile`