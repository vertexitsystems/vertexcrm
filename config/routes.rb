Rails.application.routes.draw do
    
  resources :postings
  resources :timesheets
  resources :clients
  resources :assistants
  
  resources :employers do
    collection do
      get :time_sheet_viewer
    end
  end
  
  resources :account_managers do 
    collection do 
      get :time_sheet_approval
      put :approve_or_reject
      get :filtered_vendor_report
      get :vendor_wise_data
      get :send_vendor_email
      
      get :timesheet_report
      get :reports
      get :consultant_report
      get :jobs_report
    end
  end
  
  resources :employees do
    collection do 
      get :employee_report
      put :disable_consultant
      put :enable_consultant
      get :dashboard
    end
  end
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: "users/registrations"
  }
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :destroy_user
  
  resources :vendors do 
    collection do 
      get :vendor_wise_report
    end
  end
  resources :user_types
  resources :job_applications
  resources :job_posts
  resources :profiles do
    collection do
      delete :destroy_user
    end
  end
  resources :work_durations do 
    collection do 
      get :weekly_wise_data
      put :weekly_update
      put :update_duration_status
      get :reopen_timesheet
      put :update_notification_read
      put :fix_job_issue
    end
  end
  
  resources :jobs do 
    collection do 
      put :disable_job
      get :fetch_vendor_info
    end
  end
  
  resources :projects
  
  resources :invoices do
    collection do 
      put :update_status
      
      get :approve
      put :approve_submit
      
      get :create_new_invoice
      post :generate_invoice
      get :generate_invoice
      
      put :json_employee_info
    end
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'work_durations/reopen_timesheet/:id', :to => 'work_durations#reopen_timesheet'
  
  
  root to: 'profiles#show'
end


