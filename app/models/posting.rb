class Posting < ApplicationRecord
  belongs_to :employee
  belongs_to :job
  
  has_many :work_durations
end
