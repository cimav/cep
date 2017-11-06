class CepMailer < ApplicationMailer
	include AgreementsHelper
	helper AgreementsHelper
	def vote_reminder(agreement, send_to)
		@agreement = agreement

		@from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
		@to = send_to.map(&:email).join(",")
		mail(to: @to,  :from => @from, subject: "[CEP] #{a_class_to_name(@agreement.agreeable.class.name)}")
	end
end
