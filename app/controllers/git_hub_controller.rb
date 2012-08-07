class GitHubController < ApplicationController
  def refresh
    Repository.fetch_from_github
    redirect_to :controller => 'home', :action => 'show'
  end
end
