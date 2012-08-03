require 'digest/md5'
require 'github_api'

class HomeController < ApplicationController
  def show
    org = 'Etsy-ADI-CodeCarpentry' # todo: make this a config option
    github = Github.new # todo: don't initialize every time
    # todo: move this into a model
    @repo_list = []
    repos = github.repos.list org: org
    repos.each do |repo|
      tmp = {}
      tmp[:name] = repo.name
      contributors = github.repos.contributors org, repo.name
      tmp[:contributors] = contributors.reject { |contributor|
        contributor.url.include? '/orgs/'
      }.map { |contributor|
        {:login => contributor.login, :avatar => contributor.avatar_url}
      }
      @repo_list << tmp
    end
  end
end
