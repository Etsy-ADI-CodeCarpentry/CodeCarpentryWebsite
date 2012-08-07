class Repository
  include Mongoid::Document
  field :name, type: String
  embeds_many :contributors
end
