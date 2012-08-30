namespace :data do
  desc 'Delete ev-er-y-thang'
  task clean: :environment do
    Repository.delete_all
    Commit.delete_all
    Contributor.delete_all
    LastUpdateTime.delete_all
  end

  desc 'Update all repos'
  task update: :environment do
    Repository.fetch_from_github
  end

  desc 'Reload ev-er-y-thang'
  task reload: [:clean, :update]
end