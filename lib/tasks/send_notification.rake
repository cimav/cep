task :send_notification => :environment do
  
  agreements = Agreement.where(notification_sent: Agreement::NOT_SENT, agreeable_type: 'Scholarship')
  agreements.each do |agreement|
    if agreement.status.eql? Agreement::OPEN
      send_to = []
      User.where(user_type: User::CEP).where(status:User::ACTIVE).each do |cep|
        send_to << cep
        puts cep
      end
      CepMailer.vote_reminder(agreement, send_to).deliver_now
      agreement.notification_sent =  Agreement::SENT
      agreement.save
    end
  end
end
