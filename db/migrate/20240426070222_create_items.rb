class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.references :expense, null: false, foreign_key: true
      t.string :name
      t.float :price
      t.float :quantity

      t.timestamps
    end
  end
end
