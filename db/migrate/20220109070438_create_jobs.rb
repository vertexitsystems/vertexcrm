class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.date :start_date
      t.date :end_date
      
      t.string :title
      t.float :rate
      t.text :job_description
      t.string :location
      t.integer :job_type
      
      t.date :closing_date
      t.string :closing_remarks
      
      
      t.integer :vendor_id
      t.integer :client_id
      
      t.timestamps
    end
  end
end
