# README

## Table of Contents

1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Docker Configuration](#docker-configuration)
4. [Running the Instance](#running-the-instance)
5. [Initial Setup](#initial-setup)

## Introduction
This project provides a Redmine environment using Docker, designed to simplify the process of trying out plugins and themes. It can also be used to develop plugins. It creates a database, adds initial sample data, sets up the first user password, and disables the password change request. This environment is intended for development and testing purposes only and should not be used in production.

## Setup
To get started, clone the repository from GitHub:
```bash
git clone https://github.com/tuzumkuru/redmine-plugin-tryout-sandbox.git
```
You will need to have Docker and Docker Compose installed.

## Docker Configuration
The project uses a `docker-compose.yaml` file to manage the Docker containers. The configuration includes:

* `redmine`: A Redmine container with a SQLite database.
* Volumes:
	+ `./redmine/files`: Redmine files directory.
	+ `./redmine/sqlite`: SQLite database directory.
	+ `./redmine/plugins`: Plugin code directory.
	+ `./redmine/themes`: Theme code directory.

## Running the Instance
To start the instance, run the following command:
```bash
docker-compose up --build -d
```
This will start the Redmine instance in detached mode.

## Initial Setup
When you start the instance for the first time:
* It creates the database and does the migrations.
* It creates initial sample data.
* It sets the admin password and disables the forced password change.
* The initial admin username and password are both **admin**. You can access the Redmine instance at `http://localhost:9999`.