class Contributor
  include Mongoid::Document
  field :login, type: String
  field :avatar_url, type: String
  embedded_in :repository
end
