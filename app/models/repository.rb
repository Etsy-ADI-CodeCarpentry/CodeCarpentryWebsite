require 'date'
require 'github_api'
include ActionView::Helpers::DateHelper

class Repository
  include Mongoid::Document
  field :name, type: String
  has_many :contributors
  has_many :commits

  @@org = 'Etsy-ADI-CodeCarpentry' # todo: make this a config option
  @@github = Github.new

  def self.fetch_from_github
    repos = @@github.repos.list org: @@org
    repos.each do |r|
      repo = Repository.where(name: r.name).first or Repository.create(name: r.name)
      contributors_response = @@github.repos.contributors @@org, repo.name
      contributors_response.reject { |c| c.url.include? '/orgs/' }.each do |c|
        contributor = Contributor.where(login: c.login).first
        if not contributor
          contributor = Contributor.new(
            login: c.login,
            avatar_url: c.avatar_url,
            repository: repo
          )
        end
        if not repo.contributors.where(login: contributor.login).exists?
          repo.contributors << contributor
        end
        contributor.save
      end
      commits_response = @@github.repos.commits.all @@org, repo.name
      commits_response.each do |c|
        commit = Commit.where(sha: c.sha).first
        if not commit
          date_string = c.commit.author.values_at('date')[0]
          date = DateTime.strptime(date_string, '%Y-%m-%dT%H:%M:%S%Z')
          commit = Commit.new(
            message: c.commit.message,
            contributor: repo.contributors.where(login: c.author.login).first,
            repository: repo,
            date: date,
            sha: c.sha
          )
        end
        if not repo.commits.where(sha: commit.sha).exists?
          repo.commits << commit
        end
        commit.save
      end
      repo.save
    end
  end

  def time_since_last_commit_in_words
    return time_ago_in_words(commits.sort_by { |c| c.date }.last.date)
  end

  def number_members_total
    return contributors.size
  end

  def number_members_committed_within_day
    commits_within_day = commits.reject { |c| c.date < 1.day.ago }
    return commits_within_day.group_by { |c| c.contributor_id }.size
  end
end
