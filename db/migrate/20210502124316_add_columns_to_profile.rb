class AddColumnsToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :address, :string
    add_column :profiles, :phone1, :string
    add_column :profiles, :phone2, :string
    add_column :profiles, :resume, :string
    add_column :profiles, :degree, :string
    add_column :profiles, :photo, :string
    add_column :profiles, :cnic, :string
  end
end
