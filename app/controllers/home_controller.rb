require 'digest/md5'

class HomeController < ApplicationController
  def show
    Repository.fetch_from_github
    @repos = Repository.all
  end
end
