class AgreementsController < ApplicationController

  skip_before_action :verify_authenticity_token

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
          synod_designation = agreem  ent.build_synod_designation
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
    if agreement.agreeable.destroy
      flash[:notice] = "Se eliminó el acuerdo"
    else
      flash[:error] = 'No se pudo eliminar el acuerdo'
    end
    redirect_to agreement.meeting
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
    file = AgreementFile.new(name:params[:file])
    file.agreement = agreement
    response = {}
    respond_to do |format|
      if file.save
        response[:message] = 'Documento subido'
      else
        response[:message] = 'Error al subir documento'
      end
      response[:redirect_url] = "agreements/#{agreement.id}"
      response[:errors] = file.errors.full_messages
      format.json {render json: response}

    end
  end


  private

  def agreement_params
    params.require(:agreement).permit(:meeting_id, :status, :agreement_type, :description)
  end

  def file_params
    params.require(:agreement_file).permit(:name, :file_type)
  end


end
