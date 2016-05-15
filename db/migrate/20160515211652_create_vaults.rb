class CreateVaults < ActiveRecord::Migration
  def change
    create_table :vaults do |t|
      t.string :name, null: false
      t.float :start_state, null: false
      t.belongs_to :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
