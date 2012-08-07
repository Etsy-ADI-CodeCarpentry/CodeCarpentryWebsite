require 'github_api'

class Repository
  include Mongoid::Document
  field :name, type: String
  embeds_many :contributors

  def self.fetch_from_github
    github = Github.new
    org = 'Etsy-ADI-CodeCarpentry' # todo: make this a config option
    repos = github.repos.list org: org
    repos.each do |repo_hash|
      repo = Repository.new(name: repo_hash.name)
      contributors_response = github.repos.contributors org, repo.name
      repo.contributors = contributors_response.reject { |contributor|
        contributor.url.include? '/orgs/'
      }.map { |contributor|
        Contributor.create(
          :login => contributor.login,
          :avatar_url => contributor.avatar_url,
          :repository => repo
        )
      }
      repo.upsert
    end
  end
end
