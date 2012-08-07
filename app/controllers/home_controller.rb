require 'digest/md5'

class HomeController < ApplicationController
  def show
      @repos = Repository.each
  end
end
