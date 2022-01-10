class Job < ApplicationRecord
  belongs_to :client
  belongs_to :vendor
  
  def status
    return closing_date.blank? ? "Open" : "Close"
  end
  
  def type_string
    return ["Remote", "On-Site", "Initial On-Site"][job_type]
  end
end
