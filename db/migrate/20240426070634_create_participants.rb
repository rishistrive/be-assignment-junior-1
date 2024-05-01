class CreateParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :participants do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.float :share_amount
      t.boolean :paid, default: false

      t.timestamps
    end
  end
end
