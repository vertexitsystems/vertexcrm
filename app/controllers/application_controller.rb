class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
  
  

	protected

	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
  end
  
  helper_method :has_admin_access?
  def has_admin_access?
    if !(user_signed_in? && (current_user.is_admin? || current_user.is_account_manager?))
      flash[:notice] = "You do not have permission to view this page"
      redirect_to root_path
    end
  end

end
