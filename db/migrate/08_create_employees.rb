class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.integer :rate
      t.integer :profile_id
      t.integer :vendor_id

      t.timestamps
    end
  end
end
