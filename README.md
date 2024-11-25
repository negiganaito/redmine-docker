## PLUGINS

### Done

- additional_tags
- additionals
- redmine_checklists
- redmine_contacts
- redmine_issue_templates
- redmine_issue_view_columns
- redmine_lightbox
- redmine_questions
- view_customize
- easy gantt
- easy gantt pro

### exec

> docker exec -it redmine redmine-install-plugins

### Manual

> bundle install --without development test --no-deployment

> bundle exec rake redmine:plugins NAME=redmine_agile RAILS_ENV=production

> touch tmp/restart.txt

### Remove

```bash
docker exec -it redmine bash
bundle exec rake redmine:plugins:migrate NAME=redmine_people VERSION=0
```

## THEME

### dONE

- gitmike

### exec

> docker exec -it redmine redmine-install-themes

## BASH

> docker exec -it redmine bash

## FIX CSS THEME PERMISSION

```bash
 docker exec -it redmine bash
 chown -R redmine:redmine /home/redmine/data/themes
 chmod -R 755 /home/redmine/data/themes

 docker exec -it redmine bash
 cd /home/redmine/redmine
 bundle exec rake assets:precompile RAILS_ENV=production

 docker-compose restart redmine
```

##

> docker rm $(docker ps -a -q)
