require 'date'
require 'github_api'
include ActionView::Helpers::DateHelper

class Repository
  include Mongoid::Document
  field :name, type: String
  has_many :contributors
  has_many :commits

  def self.fetch_from_github
    if not LastUpdateTime.first or LastUpdateTime.first.time < 10.minutes.ago
      LastUpdateTime.first.time = DateTime.now
      repos = Github.new.repos

      YAML::load_file(File.join(Rails.root, 'config', 'repositories.yml')).each do |config|
        config.symbolize_keys!

        repo = Repository.where(name: config[:name]).first || Repository.create(
            name: config[:name],
            description: config[:description]
        )

        repos.contributors(config[:user], config[:repo]).each do |github_contributor|
          contributor = Contributor.where(login: github_contributor.login).first || Contributor.new(
              login: github_contributor.login,
              avatar_url: github_contributor.avatar_url,
              repository: repo
          )

          repo.contributors << contributor unless repo.contributors.where(login: contributor.login).exists?
          contributor.save
        end

        repos.commits.all(config[:user], config[:repo]).each do |github_commit|
          commit = Commit.where(sha: github_commit.sha).first
          if !commit
            date_string = github_commit.commit.author.values_at('date').first
            date = DateTime.strptime(date_string, '%Y-%m-%dT%H:%M:%S%Z')
            commit = Commit.new(
                message: github_commit.commit.message,
                contributor: repo.contributors.where(login: github_commit.commit.author.login).first,
                repository: repo,
                date: date,
                sha: github_commit.sha
            )
          end

          repo.commits << commit unless repo.commits.where(sha: commit.sha).exists?
          commit.save
        end
        repo.save
      end
    end
  end

  def last_commit_date
    commits.sort_by { |c| c.date }.last.date.to_date.to_formatted_s(:long)
  end

  def time_since_last_commit_in_words_number
    time_ago_in_words(commits.sort_by { |c| c.date }.last.date).split.first
  end

  def time_since_last_commit_in_words_units
    time_ago_in_words(commits.sort_by { |c| c.date }.last.date).split.last
  end

  def number_members_total
    contributors.size
  end

  def number_members_committed_within_day
    commits_within_day = commits.reject { |c| c.date < 1.day.ago }
    commits_within_day.group_by { |c| c.contributor_id }.size
  end

  def commits_within_last_week
    commits.reject { |c| c.date < 1.week.ago }.size
  end
end
