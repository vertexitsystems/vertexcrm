class CreateEmployers < ActiveRecord::Migration[6.0]
  def change
    create_table :employers do |t|
      t.string :company_name
      t.integer :profile_id

      t.timestamps
    end
  end
end
