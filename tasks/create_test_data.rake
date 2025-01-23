namespace :redmine do
  desc "Create random projects, issues, and users in Redmine"
  task create_test_data: :environment do
    require 'faker'

    # Set Faker to use a valid locale (e.g., English)
    Faker::Config.locale = 'en'

    # Create 5 random users
    5.times do
      user = User.new(
        firstname: Faker::Name.first_name,
        lastname: Faker::Name.last_name,
        mail: Faker::Internet.email,
        login: Faker::Internet.username(specifier: 5..10),
        password: 'password123',
        password_confirmation: 'password123',
        admin: false
      )
      user.save!
      puts "Created user: #{user.login}"
    end

    # Create 5 random projects and 10 issues in each
    5.times do |i|
      project = Project.new(
        name: "Project #{i + 1}: #{Faker::Company.name}",
        identifier: "project_#{i + 1}_#{Faker::Internet.uuid[0..7]}",
        description: Faker::Company.catch_phrase,
        is_public: [true, false].sample
      )

      if project.save
        puts "Created project: #{project.name}"

        # Add random users as members of the project
        User.limit(5).each do |user|
          member = Member.new(
            project: project,
            user: user,
            roles: [Role.find_by(name: 'Developer') || Role.first]
          )
          member.save!
          puts "Added user #{user.login} to project #{project.name}"
        end

        # Create 10 random issues for the project
        10.times do
          issue = Issue.new(
            project: project,
            tracker: Tracker.first || Tracker.find_or_create_by!(name: 'Bug'),
            author: User.order('RANDOM()').first,
            subject: Faker::Lorem.sentence(word_count: 5),
            description: Faker::Lorem.paragraph(sentence_count: 3),
            priority: IssuePriority.first || IssuePriority.find_or_create_by!(name: 'Normal')
          )
          if issue.save
            puts "Created issue: #{issue.subject} in project #{project.name}"

            # Add random history to the issue
            rand(1..5).times do
              journal = Journal.new(
                journalized: issue,
                user: User.order('RANDOM()').first,
                notes: Faker::Lorem.sentence(word_count: 10)
              )
              journal.save!
              puts "Added history: #{journal.notes} to issue #{issue.subject}"
            end
          else
            puts "Failed to create issue: #{issue.errors.full_messages.join(', ')}"
          end
        end
      else
        puts "Failed to create project: #{project.errors.full_messages.join(', ')}"
      end
    end

    puts "Random data creation completed!"
  end
end
