require 'rails_helper'
require 'fabrication'
require 'faker'

RSpec.describe StaticController, type: :controller do
  describe "GET #dashboard" do
    let(:user) { Fabricate(:user) }

    before do
      sign_in user
    end

    it "assigns a new Expense object" do
      get :dashboard
      expect(assigns(:expense)).to be_a_new(Expense)
    end

    it "assigns all users to @users" do
      get :dashboard
      expect(assigns(:users)).to eq(User.all)
    end

    it "assigns a hash of user expenses to @user_expenses" do
      get :dashboard
      expect(assigns(:user_expenses)).to be_a(Hash)
    end

    it "assigns the total amount owed to the current user to @total_your_are_owed" do
      get :dashboard
      expect(assigns(:total_your_are_owed)).to eq(0)
    end

    it "assigns the total amount the current user owes to @total_you_owe" do
      get :dashboard
      expect(assigns(:total_you_owe)).to eq(0)
    end

    it "assigns the total balance for the current user to @total_balance" do
      get :dashboard
      expect(assigns(:total_balance)).to eq(0)
    end

    it "renders the dashboard template" do
      get :dashboard
      expect(response).to render_template(:dashboard)
    end
  end
end

