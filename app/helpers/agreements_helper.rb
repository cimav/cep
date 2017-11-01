module AgreementsHelper

  # Votos pendientes por usuario
  def missing_votes
    @agreements = Agreement.where(status:Agreement::OPEN).where.not(id: Response.select(:agreement_id).where(user_id:current_user.id))
  end

  def last_agreement_votes
    @last_agreement_votes = Agreement.where(id: Response.select(:agreement_id).where(user_id:current_user.id)).limit(10)
  end
end
