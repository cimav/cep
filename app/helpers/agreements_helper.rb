module AgreementsHelper

  # Votos pendientes por usuario
  def missing_votes
    @agreements = Agreement.where(status:Agreement::OPEN).where.not(id: Response.select(:agreement_id).where(user_id:current_user))
  end

end
