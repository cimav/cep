class Response < ApplicationRecord
  audited
  belongs_to :agreement
  belongs_to :user
  after_save :set_response

  validates :answer, presence:true

  # Respuestas para acuerdo genérico
  ACCEPTED = 'ACEPTAR'
  REJECTED = 'RECHAZAR'
  TO_COMMITTEE = 'RESOLVER EN COMITE'

  # Respuestas para nuevas admisiones
  PROPAEDEUTIC = 'CURSO PROPEDEUTICO'
  PROGRAM_ACCEPTED = 'ACEPTAR EN PROGRAMA'



  GENERIC_DESISIONS = {ACCEPTED => 'Aceptar', REJECTED =>'Rechazar',TO_COMMITTEE => 'Resolver en comité'}
  PROFESSIONALEXAM = GENERIC_DESISIONS
  SYNODDESIGNATION = GENERIC_DESISIONS
  TUTORCOMMITTEE = GENERIC_DESISIONS
  THESISDIRECTOR = GENERIC_DESISIONS
  NEWADMISSION = {PROGRAM_ACCEPTED => 'Aceptar en programa',PROPAEDEUTIC => 'Curso propedéutico', TO_COMMITTEE => 'Resolver en comité'}
  GENERALISSUE = GENERIC_DESISIONS
  SCHOLARSHIP = GENERIC_DESISIONS


  # Diccionario para cuando se ha tomado ya la decisión
  FINAL_DECISIONS = {
      ACCEPTED => 'Aceptado',
      REJECTED => 'Rechazado',
      TO_COMMITTEE => 'Enviado a comité',
      PROPAEDEUTIC => 'Enviado a curso propedéutico',
      PROGRAM_ACCEPTED =>'Aceptado en programa'
  }


  def set_response
    agreement = Agreement.find(self.agreement.id)
    responses = Response.where(agreement: agreement)
    # si todos los miembros del comite votaron, se cierra la votacion
    if responses.size == User.where(user_type: User::CEP).size
      # Aquí se guardarán las respuestas de cada miembro
      answers = []
      responses.each do |response|
        answers.push(response[:answer])
      end
      # Se crea un hash para obtener la respuesta más votada
      responses_hash = {}
      answers.each do |answer|
        if responses_hash[answer].nil?
          responses_hash[answer] = 1
        else
          responses_hash[answer] += 1
        end
      end
      # Obtener la decisión más votada
      more_voted = responses_hash.max_by{|k,v| v}
      number_of_members = User.where(user_type: User::CEP).size
      if more_voted[1] > number_of_members/2
        # Asignar la decisión más votada
        agreement.decision = more_voted[0]
        agreement.status = Agreement::CLOSE
        agreement.decision_date = DateTime.now
        agreement.save!
        if agreement.agreeable_type == 'Scholarship'
          ################## se cambia el estatus a la eca dependiendo de la decisión
          if more_voted[0] == ACCEPTED
            agreement.agreeable.status = Scholarship::APPROVED
          end
          if more_voted[0] == REJECTED
            agreement.agreeable.status = Scholarship::REJECTED
          end
          agreement.agreeable.save
        end
      else
        agreement.status = Agreement::CLOSE
        agreement.decision = Response::TO_COMMITTEE
        agreement.save!
      end
    end
  end
end
