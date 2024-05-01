class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :paid_by_user, class_name: 'User'
  has_many :items
  has_many :participants
end
