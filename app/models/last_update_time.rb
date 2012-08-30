require 'date'

class LastUpdateTime
  include Mongoid::Document
  field :time, type: DateTime
end
