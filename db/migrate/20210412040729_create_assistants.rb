class CreateAssistants < ActiveRecord::Migration[6.0]
  def change
    create_table :assistants do |t|
      t.string :name
      t.integer :profile_id
      t.integer :account_manager_id
      t.timestamps
    end
  end
end
