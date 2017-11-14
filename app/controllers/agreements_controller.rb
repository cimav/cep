class AgreementsController < ApplicationController
  before_action :auth_required
  include AgreementsHelper
  helper AgreementsHelper


  def index
    @agreements = Agreement.all
  end

  def show
    @agreement = Agreement.find(params[:id])
    @response = Response.new
    @ceps = User.where(user_type:User::CEP)
    render layout:false
  end

  def new
    @agreement = Agreement.new
  end

  def create
    agreement = Agreement.new(agreement_params)
    agreement.meeting_id = params[:meeting_id]
    if agreement.save
      case agreement.agreeable_type
        when Agreement::SYNOD_DESINGATION
          synod_designation = agreement.build_synod_designation
          synod_designation.student_id = params[:student_id]
          if agreement.save
            flash[:success] = "Acuerdo creado"
          end
      end

    else
      flash[:error] = "Error al crear acuerdo"
      flash[:error] = agreement.errors.full_messages[0]

    end
    redirect_to agreement.meeting
  end

  def destroy
    agreement = Agreement.find(params[:id])
    response = {}
    respond_to do |format|
      if is_admin?
        # Si el acuerdo es el último de la sesion entonces se eliminará permanentemente para que el folio se reinicie
        if agreement.consecutive == Agreement.where(meeting_id: agreement.meeting_id).maximum("consecutive")
          if agreement.agreeable.destroy
            response[:message] = 'Acuerdo eliminado permanentemente'
          else
            response[:message] = 'Error al eliminar acuerdo'
          end
        # Si no es el último entonces se cambia el estatus a "borrado"
        else
          agreement.status = Agreement::DELETED
          if agreement.save
            response[:message] = 'Acuerdo eliminado'
          else
            response[:message] = 'Error al eliminar acuerdo'
          end
        end

      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
      end
      response[:redirect_url] = "meetings/#{agreement.meeting_id}"
      response[:errors] = agreement.errors.full_messages
      format.json {render json: response}
    end
  end

  def edit
    @agreement = Agreement.find(params[:agreement_id])
    @staffs = Staff.all.order(:first_name)
    @students = Student.select("MAX(id) as id,first_name,last_name").where(:status=>[1,2,3,5,6]).group("first_name, last_name").order("first_name")
    render layout:false
  end
  def update
    agreement = Agreement.find(params[:id])
    if agreement.update(agreement_params)
      case agreement.agreement_type
        when Agreement::SYNOD_DESINGATION
        synod_designation = agreement.synod_designation
        synod_designation.student_id = params[:student_id]
        synod_designation.synodal1 = params[:synodal1]
        synod_designation.synodal2 = params[:synodal2]
        synod_designation.synodal3 = params[:synodal3]
        synod_designation.synodal4 = params[:synodal4]
        synod_designation.synodal5 = params[:synodal5]

        if synod_designation.save
          flash[:notice] = "Se actualizó el acuerdo"
        else
          flash[:error] = "No se pudo actualizar"
        end
      end
      redirect_to agreement.meeting

    else
      flash[:error] = "No se pudo actualizar"
      flash[:error] = agreement.errors.full_messages[0]
      redirect_to agreement.meeting
    end

  end

  def send_response
    agreement = Agreement.find(params[:id])
    response = {}
    respond_to do |format|
      if agreement.status == Agreement::OPEN
        user_response = Response.new
        user_response.agreement_id = agreement.id
        user_response.user_id = current_user.id
        user_response.comment = params[:response][:comment]
        user_response.answer = params[:response][:answer]



          if user_response.save
            response[:message] = 'Respuesta enviada'
          else
            response[:message] = 'Error al enviar respuesta'

          end

      else
        response[:message] = 'La votación ya se ha cerrado'
      end
      response[:redirect_url] = "agreements/#{agreement.id}"
      response[:errors] = agreement.errors.full_messages
      format.json {render json: response}

    end
  end

  def upload_file
    agreement = Agreement.find(params[:id])
    file = AgreementFile.new(file:params[:file])
    file.agreement = agreement
    f = params[:file]
    file.name = f.original_filename rescue 'Sin nombre'
    response = {}
    respond_to do |format|
      if is_admin?
        if file.save
          response[:message] = 'Documento subido'
        else
          response[:message] = 'Error al subir documento'
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
      end
      response[:redirect_url] = "agreements/#{agreement.id}"
      response[:errors] = file.errors.full_messages
      format.json {render json: response}

    end
  end

  def agreement_files
    @files = AgreementFile.where(agreement_id: params[:id])
    render layout:false
  end

  def delete_file
    file = AgreementFile.find(params[:id])
    response = {}
    respond_to do |format|
      if is_admin?
        if file.destroy
          response[:message] = 'Documento eliminado'
        else
          response[:message] = 'Error al eliminar documento'
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
      end

      response[:errors] = file.errors.full_messages
      format.json {render json: response}
    end
  end

  def display_agreement_file
    file = AgreementFile.find(params[:id]).file
    send_file file.to_s, disposition:'inline'
  end

  def student_record
    @student = Student.find(params[:student_id])
    
    render layout:false
  end

  # Mandar notificacion por email
  def send_vote_reminder
    agreement = Agreement.find(params[:agreement_id])
    response = {}
    respond_to do |format|

      # solo se notifica si el acuerdo esta abierto
      if agreement.status.eql? Agreement::OPEN
        # solo se notifica a quienes no han votado
        send_to = []
        User.where(user_type: User::CEP).each do |cep|
          if has_voted(cep, agreement)
            send_to << cep
          end
        end
        # Verificar que al menos uno de los miembros del comite no ha votado
        if send_to.size > 0
          # Se envia el correo si se está en producción
          if Rails.env.production?
            CepMailer.vote_reminder(agreement, send_to).deliver_now
            response[:message] = 'Se envio el correo'
          else
            response[:message] = 'El sistema no está en modo de producción'
          end
        else
          response[:message] = 'No hay votaciones pendientes'
        end
      else
        response[:message] = 'El acuerdo ya ha sido cerrado'
      end
      response[:redirect_url] = "agreements/#{agreement.id}"
      response[:errors] = agreement.errors.full_messages
      response[:object] = agreement
      format.json {render json: response}
    end
  end


  # Cerrar el acuerdo manualmente
  def close_agreement
    agreement = Agreement.find(params[:id])
    response = {}
    respond_to do |format|
      if is_admin?
        # verificar que el acuerdo este abierto
        if agreement.status.eql? Agreement::OPEN
          votes = Response.where(agreement: agreement)
          if votes.size > 0
            # Aquí se guardarán las respuestas de cada miembro
            answers = []
            votes.each do |response|
              answers.push(response[:answer])
            end
            # Se crea un hash para obtener la respuesta más votada
            votes_hash = {}
            answers.each do |answer|
              if votes_hash[answer].nil?
                votes_hash[answer] = 1
              else
                votes_hash[answer] += 1
              end
            end
            # Obtener la decisión más votada
            more_voted = votes_hash.max_by{|k,v| v}
            number_of_members = User.where(user_type: User::CEP).size
            if more_voted[1] > number_of_members/2
              # Asignar al acuerdo la decisión más votada
              agreement.decision = more_voted[0]
              agreement.status = Agreement::CLOSE
              if agreement.save!
                response[:message] = 'El acuerdo ha sido resuelto'
              end
            else
              agreement.status = Agreement::CLOSE
              agreement.decision = Agreement::TO_COMMITTEE
              if agreement.save!
                # Si no se obtuvo una mayoria, ek acuerdo debe resolverse en la reunion del CEP
                response[:message] = 'No se pudo llegar a una decisión'
              end
            end
          else
            response[:message] = 'Debe haber al menos un voto'
            # Debe haber al menos un voto
          end
        else
          response[:message] = 'El acuerdo ya está cerrado'
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
      end
      response[:errors] = agreement.errors.full_messages
      response[:object] = agreement
      format.json {render json: response}
    end
  end

  private

  def agreement_params
    params.require(:agreement).permit(:meeting_id, :status, :agreement_type, :description)
  end

  def file_params
    params.require(:agreement_file).permit(:file, :name, :file_type)
  end


end
