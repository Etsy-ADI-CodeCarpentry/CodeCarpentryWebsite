#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

CodeCarpentryWebsite::Application.load_tasks

namespace :github do
  desc 'Refresh information from GitHub'
  task :refresh => :environment do
    LastUpdateTime.first.time = 11.minutes.ago
    Repository.fetch_from_github
  end
end
