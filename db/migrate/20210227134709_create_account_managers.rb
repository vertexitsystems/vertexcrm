class CreateAccountManagers < ActiveRecord::Migration[6.0]
  def change
    create_table :account_managers do |t|
      t.string :name
      t.integer :profile_id

      t.timestamps
    end
  end
end
