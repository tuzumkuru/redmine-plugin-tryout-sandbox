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

  # Check if the Gemfile contains the faker gem and remove it
  if grep -q 'gem ["'\'']faker["'\'']' /usr/src/redmine/Gemfile; then
    echo "Faker gem found in Gemfile, removing it..."
    sed -i -e "\$s/\s*gem 'faker'\s*$//" /usr/src/redmine/Gemfile  # Remove faker since it creates errors
    echo "Faker gem removed from Gemfile."
    echo "Running 'bundle clean --force' to clean up any unused gems..."
    bundle clean --force
    echo "'bundle clean --force' completed."
  else
    echo "Faker gem not found in Gemfile."
  fi



  # Create flag file to indicate setup is done
  touch "$FLAG_FILE"
fi

# Do plugin migrations before every start
rails redmine:plugins:migrate

# Start the rails server
rails server -e development -b 0.0.0.0