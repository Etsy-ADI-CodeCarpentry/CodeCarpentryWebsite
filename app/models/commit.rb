require 'date'

class Commit
  include Mongoid::Document
  field :message, type: String
  field :sha, type: String
  field :date, type: DateTime
  belongs_to :contributor
  belongs_to :repository
end
