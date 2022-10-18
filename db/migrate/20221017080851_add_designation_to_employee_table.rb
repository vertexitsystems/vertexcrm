class AddDesignationToEmployeeTable < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :designation, :string
  end
end
