require 'digest/md5'

class HomeController < ApplicationController
  def show
      @hashes = [Digest::MD5.hexdigest('shardisty@etsy.com'.strip.downcase),Digest::MD5.hexdigest('znewman01@gmail.com'.strip.downcase)]
  end
end
