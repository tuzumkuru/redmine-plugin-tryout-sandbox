#!/bin/bash

# Do bundle install at every start in case there is a new gem from plugins
export RAILS_ENV=development
bundle config set --local without ""
bundle config set with 'development'
bundle install

# Flag file to indicate if initial setup has been done before
FLAG_FILE="/usr/src/redmine/initial_setup_done"

# Check if setup should be skipped based on an environment variable
if [ "${SKIP_INITIAL_SETUP}" != "true" ] && [ ! -f "$FLAG_FILE" ]; then
  # Run database migrations and initial setup  
  rails db:migrate
  echo 'en' | rails redmine:load_default_data

  # Add faker gem to Gemfile dynamically if not already present
  if ! grep -q "gem ['\"]faker['\"]" /usr/src/redmine/Gemfile; then
    echo "Adding faker gem to Gemfile..."
    echo "gem 'faker'" >> /usr/src/redmine/Gemfile
    bundle install
    ADDED_FAKER=true
  else
    echo "Faker gem is already in Gemfile."
    ADDED_FAKER=false
  fi

  # Run tasks that depend on the faker gem
  rails redmine:create_test_data

  # Remove faker gem from Gemfile if it was added by this script
  if [ "$ADDED_FAKER" = true ]; then
    echo "Removing faker gem from Gemfile..."
    sed -i "/gem 'faker'/d" /usr/src/redmine/Gemfile
    echo "Running 'bundle clean --force' to clean up unused gems..."
    bundle clean --force
    echo "'bundle clean --force' completed."
  fi

  # Set admin password
  rails redmine:set_admin_password

  # Create flag file to indicate setup is done
  touch "$FLAG_FILE"
fi

# Do plugin migrations before every start
rails redmine:plugins:migrate

# Remove the server PID file if it exists
rm -f /usr/src/redmine/tmp/pids/server.pid

# Start the rails server
rails server -e development -b 0.0.0.0
