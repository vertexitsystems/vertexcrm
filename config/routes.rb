Rails.application.routes.draw do
  resources :assistants
  resources :employers
  resources :account_managers do 
    collection do 
      get :time_sheet_approval
      put :approve_or_reject
      get :filtered_vendor_report
      get :vendor_wise_data
      get :send_vendor_email
      
      get :timesheet_report
    end
  end
  resources :employees do
    collection do 
      get :employee_report
    end
  end
  devise_for :users
  resources :vendors do 
    collection do 
      get :vendor_wise_report
    end
  end
  resources :user_types
  resources :job_applications
  resources :job_posts
  resources :profiles
  resources :work_durations do 
    collection do 
      get :weekly_wise_data
      put :weekly_update
      put :update_duration_status
    end
  end
  resources :projects
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  
  
  root to: 'profiles#show'
end


