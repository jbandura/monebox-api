class CreateVaultOperations < ActiveRecord::Migration
  def change
    create_table :vault_operations do |t|
      t.string :type, null: false
      t.integer :amount, null: false
      t.belongs_to :vault, index: true, foreign_key: true, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
