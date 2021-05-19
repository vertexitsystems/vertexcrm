class CreateJobApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :job_applications do |t|
      t.string :email
      t.string :ph_no
      t.text :cover_letter

      t.timestamps
    end
  end
end
