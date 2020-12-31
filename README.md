# About

This solution extends

# Extended cli parameters

## configUrl

It is url to project with a configuration, that can be loaded with git. The project may inherit
defined structure to make liquibase options configuration simpler.

Be careful, if this parameter is defined extended configuration will be used.

### The suggested structure of project with configuration

```
    <root>
        /migration-config
            /changelog
                0--changeset.sql
                main.xml
            liquibase.docker.properties
```

## configBranch: optional (by default, master)