class User < ApplicationRecord
	has_one :profile, dependent: :destroy
	

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def is_admin? 
  	return profile.role == "Admin"
  end
  def is_employee? 
  	return profile.role == "Employee"
  end
  def is_account_manager?
    profile.role == "Account Manager"
  end
  def is_vendor?
    profile.role == "Vendor"
  end
end
