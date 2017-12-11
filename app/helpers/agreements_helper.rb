module AgreementsHelper

  # Votos pendientes por usuario
  def missing_votes
    @agreements = Agreement.where(status:Agreement::OPEN).where(meeting: Meeting.where(status: Meeting::OPENED)).where.not(id: Response.select(:agreement_id).where(user_id:current_user.id))
  end

  def last_agreement_votes
    @last_agreement_votes = Agreement.where(id: Response.select(:agreement_id).where(user_id:current_user.id)).limit(10)
  end

  def has_voted(user,agreement)
    Response.where(user:user).where(agreement:agreement).first.nil?
  end

  def a_class_to_name(agreement_class)
    case agreement_class
      when "NewAdmission"
      "Nuevo ingreso"
      when "SynodDesignation"
      "Designación de sinodales"
      when "ProfessionalExam"
      "Examen de grado"
      when "TutorCommittee"
        "Designación de comité tutoral"
      when "ThesisDirector"
        "Director de tesis"
      when "GeneralIssue"
        "Asuntos generales"
    end
  end

end

