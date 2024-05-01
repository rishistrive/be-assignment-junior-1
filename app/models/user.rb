class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :participants
  has_many :expenses
  has_many :paid_expenses, foreign_key: :paid_by, class_name: 'Expense'

  scope :with_participants_and_paid_by_user, ->(user_id) {
    joins(participants: { expense: :paid_by_user })
      .where(participants: { user_id: user_id })
  }

  scope :settle_up_for_user, ->(user_id) {
    with_participants_and_paid_by_user(user_id)
      .where.not(expenses: { paid_by: user_id })
      .where(participants: { paid: false })
      .pluck('"paid_by_users_expenses"."name"', 'participants.share_amount', 'participants.paid', 'participants.user_id')
      .map do |name, share_amount, paid, user_id|
        {
          name: name,
          share_amount: share_amount,
          paid: paid,
          user_id: user_id
        }
      end
  }

  scope :you_owe_to_other, ->(user_id) {
    with_participants_and_paid_by_user(user_id)
      .where.not(expenses: { paid_by: user_id })
      .pluck('"paid_by_users_expenses"."name"', 'participants.share_amount', 'participants.paid')
  }

  scope :you_owed_by_other, ->(user_id) {
    joins(participants: :expense)
      .where(expenses: { paid_by: user_id })
      .where.not(participants: { user_id: user_id })
      .pluck(:name, :share_amount, 'participants.paid')
  }
end
