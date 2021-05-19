class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.integer :employee_id
      t.integer :vendor_id
      t.integer :rate

      t.timestamps
    end
  end
end
