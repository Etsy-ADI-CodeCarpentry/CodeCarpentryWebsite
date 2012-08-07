require 'digest/md5'

class HomeController < ApplicationController
  def show
      @repos = Repository.all
  end
end
