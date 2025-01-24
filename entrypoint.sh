#!/bin/bash

set -euo pipefail  # Enable strict error handling

RAILS_ENV=development
FLAG_FILE="/usr/src/redmine/initial_setup_done"
GEMFILE="/usr/src/redmine/Gemfile"
RAILS_DIR="/usr/src/redmine"

# Initialize bundler settings and install gems
initialize_bundler() {
  echo "Initializing Bundler..."
  bundle config set --local without ""
  bundle config set with "$RAILS_ENV"
  bundle install
}

# Perform initial setup tasks, ensuring they're only run once
initial_setup() {
  echo "Checking if initial setup is needed..."
  if [ ! -f "$FLAG_FILE" ]; then
    echo "Initial setup is being executed for the first time."
    rails db:migrate
    echo 'en' | rails redmine:load_default_data
    add_faker_gem
    rails redmine:create_test_data
    remove_faker_gem_if_needed
    rails redmine:set_admin_password
    touch "$FLAG_FILE"
  else
    echo "Initial setup has already been completed. Skipping."
  fi
}

# Add the `faker` gem for test data generation
add_faker_gem() {
  echo "Checking if faker gem needs to be added..."
  if ! grep -q "gem ['\"]faker['\"]" "$GEMFILE"; then
    echo "Adding faker gem to Gemfile..."
    echo "gem 'faker'" >> "$GEMFILE"
    bundle install
    export ADDED_FAKER=true
  else
    echo "Faker gem is already present in Gemfile. No need to add."
    export ADDED_FAKER=false
  fi
}

# Remove the `faker` gem from the Gemfile if it was added by this script
remove_faker_gem_if_needed() {
  if [ "${ADDED_FAKER:-false}" = true ]; then
    echo "Removing faker gem from Gemfile since it was added during this run."
    sed -i "/gem 'faker'/d" "$GEMFILE"
    echo "Cleaning up unused gems using 'bundle clean --force'."
    bundle clean --force
  else
    echo "Faker gem was not added by this run. No removal needed."
  fi
}

# Run `chown` if the environment variable is set
run_chown_if_required() {
  echo "Checking if chown should be executed..."
  if [ "${RUN_CHOWN:-false}" = "true" ]; then
    echo "Running chown on $RAILS_DIR."
    chown www-data:www-data "$RAILS_DIR" -R
  else
    echo "Skipping chown as RUN_CHOWN is not set to true."
  fi
}

# Execute plugin migrations and start the server
start_server() {
  echo "Executing plugin migrations..."
  rails redmine:plugins:migrate
  
  echo "Removing any existing server PID file."
  rm -f "$RAILS_DIR/tmp/pids/server.pid"
  
  echo "Starting Rails server..."
  rails server -e "$RAILS_ENV" -b 0.0.0.0
}

# Main script execution
main() {
  initialize_bundler
  if [ "${SKIP_INITIAL_SETUP:-false}" != "true" ]; then
    initial_setup
  else
    echo "Skipping initial setup due to SKIP_INITIAL_SETUP being set to true."
  fi
  run_chown_if_required
  start_server
}

main "$@"