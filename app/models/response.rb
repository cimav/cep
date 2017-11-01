class Response < ApplicationRecord
  belongs_to :agreement
  belongs_to :user
  after_save :set_response

  validates :answer, presence:true

  ACCEPTED = 1
  REJECTED = 2
  TO_COMMITTEE = 3

  DESISIONS = {ACCEPTED => "Aceptar", REJECTED =>"Rechazado",TO_COMMITTEE => "Resolver en comité"}


  def get_decision
    DESISIONS[self.answer]
  end

  def set_response
    agreement = Agreement.find(self.agreement.id)
    responses = Response.where(agreement: agreement)
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
      # Asignar el nivel más votado
      more_voted = responses_hash.max_by{|k,v| v}
      number_of_members = User.where(user_type: User::CEP).size
      if more_voted[1] > number_of_members/2
        agreement.decision = more_voted[0]
        agreement.status = Agreement::CLOSE
        agreement.save!
      else
        agreement.status = Agreement::REJECTED
        agreement.save!
      end

    end
  end
end
