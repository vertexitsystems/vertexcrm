class CreateJobPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :job_posts do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
