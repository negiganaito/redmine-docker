# Redmine Docker Setup with Plugins, Themes, and Permissions Fix

This README provides a step-by-step guide for setting up a Redmine Docker environment, including plugin and theme installation, CSS fixes, and troubleshooting.

## PLUGINS

### The following plugins have been successfully installed:

- easy_baseline
- easy_gantt
- easy_gantt_pro
- redmica_ui_extension
- redmine_checklists
- redmine_contacts
- redmine_drive
- redmine_logs
- redmine_people
- redmine_questions
- redmine_resources
- redmine_zenedit
- redmineup_cms
- redmineup_tags

### Install Plugins

#### Using Docker Exec

Run the following command to install plugins in the Redmine Docker container:

```bash
docker exec -it redmine redmine-install-plugins
```

Manual Installation

1. Install dependencies:

```bash
bundle install --without development test --no-deployment
```

2. Run plugin migrations (replace redmine_agile with the desired plugin name):

```bash
bundle exec rake redmine:plugins NAME=redmine_agile RAILS_ENV=production
```

3. Restart Redmine:

```bash
touch tmp/restart.txt
```

### Remove a Plugin

To remove a plugin (e.g., redmine_people), follow these steps:

1. Open a bash shell inside the container:

```bash
docker exec -it redmine bash
```

2. Rollback the plugin migration:

```bash
bundle exec rake redmine:plugins:migrate NAME=redmine_issue_view_columns VERSION=0
```

3. Restart

```bash
touch tmp/restart.txt
```

## THEMES

### Installed Themes

highrise

### Install Themes

Use the following command to install themes in the Redmine Docker container:

```bash
docker exec -it redmine redmine-install-themes
```

## FIX CSS THEME PERMISSIONS (ver 6.0)

```bash
docker exec -it redmine bash
chown -R redmine:redmine /home/redmine/data/themes
chmod -R 755 /home/redmine/data/themes
cd /home/redmine/redmine
bundle exec rake assets:precompile RAILS_ENV=production
docker-compose restart redmine
```

## GENERAL COMMANDS

### Access Bash in Container

To access the Redmine container's shell:

```bash
docker exec -it redmine bash
```

### Remove All Stopped Containers

Use this command to clean up stopped containers:

```bash
docker rm $(docker ps -a -q)
```
