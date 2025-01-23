# README

## Introduction
This project provides a Redmine environment using Docker, designed to simplify the process of trying out plugins and themes. It can also be used to develop plugins. This environment is intended for development and testing purposes only and should not be used in production.

## Getting Started
To get started, follow these steps:

1. Clone the repository:
```bash
git clone https://github.com/tuzumkuru/redmine-plugin-tryout-sandbox.git
```
2. Install Docker and Docker Compose if you haven't already.
3. Navigate to the project directory:
```bash
cd redmine-plugin-tryout-sandbox
```
4. Start the instance in detached mode:
```bash
docker compose up --build -d
```
5. Access the Redmine instance at `http://localhost:9999`. The initial admin username and password are both **admin**.

## Initial Setup
When you start the instance for the first time, it will create the database, perform migrations, create initial sample data, and set the admin password.

## Data Generation
The `create_test_data.rake` task is used to create random projects, issues, and users in Redmine. This task is run automatically during the initial setup. Note that the Faker gem is temporarily used to generate this data, but it is removed from the Gemfile after data generation to avoid errors in Redmine.

## Docker Configuration
The project uses a `docker-compose.yaml` file to manage the Docker containers. The configuration includes:

* `redmine`: A Redmine container with a SQLite database.
* Volumes:
	+ `./redmine/files`: Redmine files directory.
	+ `./redmine/sqlite`: SQLite database directory.
	+ `./redmine/plugins`: Plugin code directory.
	+ `./redmine/themes`: Theme code directory.

## Developing Plugins
To develop plugins, create a new directory in the `./redmine/plugins` directory and add your plugin code. The `entrypoint.sh` file will take care of running the plugin migrations before every start.

## Contributing
Contributions are welcome! If you'd like to contribute to this project, please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License.