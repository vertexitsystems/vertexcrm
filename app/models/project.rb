class Project < ApplicationRecord
	belongs_to :employee
	belongs_to :vendor

	has_many :work_durations

	def today
  		return Date.today
  	end
  	def days_from_this_week 
  		return (today.at_beginning_of_week..today.at_end_of_week).map
  	end
  	def weekly_hours_worked
  		hours_worked = []
  		for day in (created_at.to_datetime.at_beginning_of_week..today.at_end_of_week).map.each { |day| day } do
  			wd = WorkDuration.where(work_day:day, project_id:id)
  			if wd.count > 0
  				hours_worked << wd.first.hours
  			end
  		end

  		return hours_worked
  	end
  	def total_weekly_hours_worked 
  		return weekly_hours_worked.reject { |item| item.blank? }.reduce(&:+)
  	end

    def weekly_earnings
      return total_weekly_hours_worked != nil ? total_weekly_hours_worked * rate : 0
    end
    def total_weekly_hours_worked 
      return weekly_hours_worked.reject { |item| item.blank? }.reduce(&:+)
    end
end
