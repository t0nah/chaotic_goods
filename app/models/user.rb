class User < ApplicationRecord
  validates :name, presence: true
  has_many :cart_items


end
