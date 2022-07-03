class User < ApplicationRecord
  has_one :profile#, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def is_admin?
    profile.role == 'Admin'
  end

  def is_employee?
    !profile.employee.blank?#profile.role == 'Employee'
  end
  
  def is_employer?
    profile.role == 'Employer' && !profile.employer.blank?
  end

  def is_account_manager?
    profile.role == 'Account Manager'
  end

  def is_vendor?
    profile.role == 'Vendor'
  end
end
