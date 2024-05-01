require 'rails_helper'
require 'fabrication'
require 'faker'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:participants) }
    it { should have_many(:expenses) }
    it { should have_many(:paid_expenses).with_foreign_key(:paid_by).class_name('Expense') }
  end

  describe 'scopes' do
    let!(:user) { Fabricate(:user) }
    let!(:other_user) { Fabricate(:user) }
    let!(:expense) { Fabricate(:expense, paid_by: user.id) }
    let!(:participant) { Fabricate(:participant, user_id: other_user.id, expense_id: expense.id) }

    describe '.with_participants_and_paid_by_user' do
      it 'returns users with participants and paid by user' do
        expect(User.with_participants_and_paid_by_user(other_user.id)).to include(other_user)
      end
    end

    describe '.settle_up_for_user' do
      it 'returns data for settling up' do
        expect(User.settle_up_for_user(other_user.id)).to include(
          {
            name: expense.paid_by_user.name,
            share_amount: participant.share_amount,
            paid: participant.paid,
            user_id: participant.user_id
          }
        )
      end
    end

    describe '.you_owe_to_other' do
      it 'returns data for what user owes to others' do
        expect(User.you_owe_to_other(other_user.id)).to include([expense.paid_by_user.name, participant.share_amount, participant.paid])
      end
    end

    describe '.you_owed_by_other' do
      it 'returns data for what user is owed by others' do
        expect(User.you_owed_by_other(user.id)).to include([participant.user.name, participant.share_amount, participant.paid])
      end
    end
  end
end
