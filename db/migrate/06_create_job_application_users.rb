class CreateJobApplicationUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :job_application_users do |t|
      t.integer :job_application_id
      t.integer :user_id
    end
  end
end
