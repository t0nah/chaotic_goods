class Order < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :status, presence: true
  validates :order_amount, presence: true
end
