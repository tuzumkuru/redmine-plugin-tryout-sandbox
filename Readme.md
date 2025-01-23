# README

## Table of Contents

1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Environment Variables](#environment-variables)
4. [Docker Configuration](#docker-configuration)
5. [Plugin Development](#plugin-development)
6. [Rake Tasks](#rake-tasks)
7. [Troubleshooting](#troubleshooting)

## Introduction
This project provides a Redmine plugin development environment using Docker. The environment is pre-configured to run Redmine with a SQLite database and includes a sample plugin.

## Setup
To get started, clone the repository and update the `.env` file with your plugin name:

```bash
PLUGIN_NAME=your_plugin_name
```

## Environment Variables
The following environment variables are used in the project:

* `PLUGIN_NAME`: The name of your plugin, defined in the `.env` file.

## Docker Configuration
The project uses a `docker-compose.yaml` file to manage the Docker containers. The configuration includes:

* `redmine`: A Redmine container with a SQLite database.
* Volumes:
	+ `./.volumes/files`: Redmine files directory.
	+ `./.volumes/sqlite`: SQLite database directory.
	+ `./${PLUGIN_NAME}`: Plugin code directory.

## Plugin Development
To develop your plugin, create a new directory with your plugin name in the root directory of the project. Add your plugin code to this directory. The folder name must be the same as the PLUGIN_NAME defined in .env file. 

## Rake Tasks
The project includes several Rake tasks for managing the Redmine environment:

* `create_test_data`: Creates a test project and issue.
* `set_admin_password`: Sets the admin password and disables forced password change.

These tasks are run automatically when the Docker container starts. 

## Troubleshooting
If you encounter any issues, check the following:

* The `docker-compose.yaml` file for correct container configuration.
* The `Dockerfile` for correct plugin installation and configuration.
* The `create_test_data.rake` and `set_admin_password.rake` files for correct Rake task implementation.

For more information, refer to the Redmine documentation and the Docker documentation.