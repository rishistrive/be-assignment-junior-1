class StaticController < ApplicationController
  def dashboard
    @expense = Expense.new
    @users = User.all
    @user_expenses = @users.map { |user| [user.id, user.expenses] }.to_h
    @total_your_are_owed = Expense.owed_to_user(current_user.id).round(2) rescue 0
    @total_you_owe = Expense.owed_by_user(current_user.id).round(2) rescue 0
    @total_balance = Expense.balance_for_user(current_user.id).round(2)
    @settle_up = User.settle_up_for_user(current_user.id) rescue nil
    @you_owe_to_other = User.you_owe_to_other(current_user.id) rescue nil
    @you_owed_by_other = User.you_owed_by_other(current_user.id) rescue nil
  end

  def person
  end
end
