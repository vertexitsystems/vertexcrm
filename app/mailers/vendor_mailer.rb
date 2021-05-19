class VendorMailer < ApplicationMailer
	default from: "requirement@vertexitservice.com"

	def vendor_notification
		@profile = params[:profile]
		@link = params[:link]
		# attachments["report.pdf"] = WickedPdf.new.pdf_from_url(@link) if @link.present?
		file = open(@link).read
		attachments["report.pdf"] = file if @link.present?
		mail(to:@profile.user.email,subject: "Vendor Wise Report!")
	end
end