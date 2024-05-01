require 'rails_helper'
require 'fabrication'
require 'faker'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:paid_by_user).class_name('User')}
    it { should have_many(:items) }
    it { should have_many(:participants) }
    it { should accept_nested_attributes_for(:items) }
    it { should accept_nested_attributes_for(:participants) }
  end

  describe 'scopes' do
    describe '.owed_to_user' do
      let!(:user) { Fabricate(:user) }
      let!(:user_1) { Fabricate(:user) }
      let!(:expense_1) { Fabricate(:expense, paid_by: user.id) }
      let!(:expense_2) { Fabricate(:expense) }
      let!(:participant_1) { Fabricate(:participant, expense_id: expense_1.id, user_id: user_1.id, share_amount: 50, paid: false) }

      it 'calculates the amount owed to the user' do
        expect(Expense.owed_to_user(user.id)).to eq(50) # Assuming sum of share_amount for expense_1's participants
      end
    end

    describe '.owed_by_user' do
      let!(:user) { Fabricate(:user) }
      let!(:user_1) { Fabricate(:user) }
      let!(:expense_1) { Fabricate(:expense, paid_by: user.id) }
      let!(:expense_2) { Fabricate(:expense) }
      let!(:participant_1) { Fabricate(:participant, expense_id: expense_1.id, user_id: user_1.id, share_amount: 50, paid: false) }

      it 'calculates the amount owed to the user' do
        expect(Expense.owed_by_user(user_1.id)).to eq(50) # Assuming sum of share_amount for expense_1's participants
      end
    end

    describe '.balance_for_user' do
      let!(:user) { Fabricate(:user) }
      let!(:user_1) { Fabricate(:user) }
      let!(:expense_1) { Fabricate(:expense, paid_by: user.id) }
      let!(:expense_2) { Fabricate(:expense) }
      let!(:participant_1) { Fabricate(:participant, expense_id: expense_1.id, user_id: user_1.id, share_amount: 50, paid: false) }

      it 'calculates the balance for the user' do
        owed_to_user = Expense.owed_to_user(user.id)
        owed_by_user = Expense.owed_by_user(user.id)
        expected_balance = (owed_to_user - owed_by_user).round(2)
        expect(Expense.balance_for_user(user.id)).to eq(expected_balance)
      end
    end
  end

  describe 'callbacks' do
    describe 'share_amount_to_participant' do
      let!(:user) { Fabricate(:user) }
      let!(:user_1) { Fabricate(:user) }
      let(:expense) { Fabricate(:expense, paid_by: user.id) }
      let(:item1) { Fabricate(:item, expense: expense, price: 10) }
      let(:item2) { Fabricate(:item, expense: expense, price: 20) }
      let(:participant1) { Fabricate(:participant, expense: expense, user: user) }
      let(:participant_2) { Fabricate(:participant, expense: expense, user: user_1) }
      
      before do
        expense.update(tax: 5, tip: 2)
        expense.save
      end

      it 'calculates and updates share_amount for each participant' do
        total_amt = item1.price + item1.price + (item1.price + item1.price) / 100 * 5 + 2
        share_amount = total_amt / 2 # Assuming there are two participants

        participant1.update(share_amount: share_amount)
        participant_2.update(share_amount: share_amount)

        expect(participant1.share_amount).to eq(share_amount)
        expect(participant_2.share_amount).to eq(share_amount)
      end
    end
  end
end
