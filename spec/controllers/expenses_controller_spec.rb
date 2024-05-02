require 'rails_helper'
require 'fabrication'
require 'faker'

RSpec.describe ExpensesController, type: :controller do
  let(:user) { Fabricate(:user) }
  let(:expense) { Fabricate(:expense, paid_by: user.id)}
  let(:expense_params) { { description: 'Test Expense', paid_by: user.id, tax: 5, tip: 2 } }

  describe 'POST #create' do
    it 'creates a new expense' do
      sign_in user
      post :create, params: { expense: expense_params }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Expense was successfully created.')
    end
  end

  describe 'PATCH #settle_up' do
    let(:participant) { Fabricate(:participant, user: user, paid: false, expense_id: expense.id) }

    it 'marks the participant as paid' do
      sign_in user
      patch :settle_up, params: { user_id: user.id, share_amount: participant.share_amount }
      expect(participant.reload.paid).to eq(true)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Expense Paid')
    end
  end
end
