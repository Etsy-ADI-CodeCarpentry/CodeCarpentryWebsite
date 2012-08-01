namespace :dev do
  namespace :start do
    task :mongo do
      Daemons.daemonize
      sh "mongod --dbpath=#{File.join(Rails.root, 'tmp')}"
    end
  end

  desc 'Fire up the databases'
  task start: %w{dev:start:mongo}

  task yes_i_am_sure: %w{db:drop db:create db:mongoid:create_indexes db:seed}
end
