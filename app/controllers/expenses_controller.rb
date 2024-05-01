class ExpensesController < ApplicationController

  def new
    @expense = Expense.new
    @users = User.all
  end

  def create
    @expense = current_user.expenses.new(expense_params)
    if @expense.save
      expense_paid_by_user(@expense)
      redirect_to root_path, notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  def settle_up
    user = User.find_by(id: params[:user_id])
    amount = params[:share_amount]
    participant = Participant.find_by(user_id: user, share_amount: amount)
    if participant.update(paid: true)
      redirect_to root_path, notice: 'Expense Paid'
    else
      redirect_to root_path
    end
  end

  private

  def expense_paid_by_user(expense)
    participant = expense.participants.find_by(user_id: expense_params[:paid_by])
    participant.update_columns(paid: true) if participant
  end

  def expense_params
    params.require(:expense).permit(:description, :paid_by, :tax, :tip, items_attributes: [:name, :price, :quantity], participants_attributes: [:user_id])
  end
end
