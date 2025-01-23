FROM redmine:latest

# Install required packages
RUN apt update && apt install -y gcc make
RUN echo "development:\n  adapter: sqlite3\n  database: /usr/src/redmine/sqlite/redmine.db" > /usr/src/redmine/config/database.yml
RUN mkdir -p /usr/src/redmine/sqlite && chown -R 999:999 /usr/src/redmine/sqlite

# Adjust Rails environment settings
RUN sed -i '/^end$/i config.hosts.clear' /usr/src/redmine/config/environments/development.rb

# Copy custom rake task
COPY tasks/create_test_data.rake lib/tasks/
COPY tasks/set_admin_password.rake lib/tasks/

# Copy entrypoint script
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Set up working directory
WORKDIR /usr/src/redmine

# Set up the entrypoint
ENTRYPOINT ["/entrypoint.sh"]