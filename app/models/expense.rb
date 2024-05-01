class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :paid_by_user, foreign_key: :paid_by, class_name: 'User'
  has_many :items
  has_many :participants

  accepts_nested_attributes_for :items
  accepts_nested_attributes_for :participants

  after_save :share_amount_to_participant

  scope :owed_to_user, ->(user_id) {
    joins(participants: :expense)
      .where(paid_by: user_id)
      .where.not(participants: { user_id: user_id })
      .where(participants: { paid: false })
      .sum("participants.share_amount")
  }

  scope :owed_by_user, ->(user_id) {
    joins(participants: :expense)
      .where.not(paid_by: user_id)
      .where(participants: { user_id: user_id })
      .where(participants: { paid: false })
      .sum("participants.share_amount")
  }

  scope :balance_for_user, ->(user_id) {
    owed_to_user = owed_to_user(user_id)
    owed_by_user = owed_by_user(user_id)
    (owed_to_user - owed_by_user).round(2)
  }

  def share_amount_to_participant
    total_amt = self.items.pluck(:price).compact.sum
    total_amt += (total_amt / 100 * self.tax) + self.tip
    update_columns(amount: total_amt)
    participants = self.participants
    share_amount = self.amount / participants.count
    participants.update_all(share_amount: share_amount.round(2))
  end
end
