class Project < ApplicationRecord
  after_destroy :destroy_associations
  
  belongs_to :employee
  belongs_to :vendor

  has_many :work_durations

  def name
    "Proj#{id}"
  end
  def today
    Date.today
  end
  
  def display_id
    "P#{id}#{created_at.strftime("%b").upcase}#{created_at.strftime("%d%y")}"
  end
  
  def days_from_this_week
    (today.at_beginning_of_week..today.at_end_of_week).map
  end

  def weekly_hours_worked
    hours_worked = []
    (created_at.to_datetime.at_beginning_of_week..today.at_end_of_week).map.each { |day| day }.each do |day|
      wd = WorkDuration.where(work_day: day, project_id: id)
      hours_worked << wd.first.hours if wd.count > 0
    end

    hours_worked
  end

  def total_weekly_hours_worked
    weekly_hours_worked.reject { |item| item.blank? }.reduce(&:+)
  end

  def weekly_earnings
    !total_weekly_hours_worked.nil? ? total_weekly_hours_worked.to_i * rate.to_i : 0
  end

  def total_weekly_hours_worked
    weekly_hours_worked.reject { |item| item.blank? }.reduce(&:+)
  end
  
  private

  def destroy_associations
    self.work_durations.destroy_all
  end
end
