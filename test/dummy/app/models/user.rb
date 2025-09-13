class User < ApplicationRecord
  self.primary_key = "id"

  has_many :posts
end
