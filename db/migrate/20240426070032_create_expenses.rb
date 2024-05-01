class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.float :amount
      t.integer :paid_by
      t.text :description
      t.float :tax, default: 0.0
      t.float :tip, default: 0.0

      t.timestamps
    end
  end
end
