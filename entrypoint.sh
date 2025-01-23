#!/bin/bash

# Do bundle install at every start in case there is a new gem from plugins
export RAILS_ENV=development
bundle config set --local without ""
bundle config set with 'development'
bundle install

# Flag file to indicate if initial setup has been done before
FLAG_FILE="/usr/src/redmine/initial_setup_done"

# Check if setup has been done before
if [ ! -f "$FLAG_FILE" ]; then
  # Run database migrations and initial setup  
  rails db:migrate
  echo 'en' | rails redmine:load_default_data
  rails redmine:create_test_data
  rails redmine:set_admin_password

  # Create flag file to indicate setup is done
  touch "$FLAG_FILE"
fi

# Do plugin migrations before every start
rails redmine:plugins:migrate

# Start the rails server
rails server -e development -b 0.0.0.0