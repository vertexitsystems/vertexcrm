class WorkDuration < ApplicationRecord
	belongs_to :project
	has_one :vendor,through: :project
	has_one :employee,through: :project
	enum time_sheet_status: %i[pending approved rejected]

	validates :hours, inclusion: { in: 0..10,
    message: "%{value} is not in between 0 to 10" }
end
