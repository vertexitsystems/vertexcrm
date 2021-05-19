class EmployeeMailer < ApplicationMailer

	def reminder
		@employee = params[:employee]
		 mail(
		   to: email_address_with_name(@employee.user.email, @employee.name),
		   subject: 'Reminder!'
		 )
	end
end