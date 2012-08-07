class Contributor
  include Mongoid::Document
  field :login, type: String
  field :name,  type: String
  field :avatar_url, type: String
  has_many :commits
  belongs_to :repository
end
