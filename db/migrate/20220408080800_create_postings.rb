class CreatePostings < ActiveRecord::Migration[6.0]
  def change
    create_table :postings do |t|
      
      t.date :start_date
      t.date :end_date
      
      t.integer :employee_id
      t.integer :job_id
      
      t.timestamps
    end
  end
end
