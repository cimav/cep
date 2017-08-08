class NewAdmissionsController < ApplicationController

  def create
    new_admission = NewAdmission.new(new_admission_params)
    if new_admission.save

      agreement = new_admission.build_agreement
      agreement.description = params[:description]
      agreement.meeting_id = params[:meeting_id]
      if new_admission.save
        flash[:success] = "Acuerdo creado"
      else
        flash[:error] = "Error al crear acuerdo"
        flash[:error] = agreement.errors.full_messages[0]
      end

    else
      flash[:error] = "Error al crear acuerdo"
      flash[:error] = new_admission.errors.full_messages[0]

    end
    redirect_to Meeting.find(params[:meeting_id])

  end

  def update
    new_admission = NewAdmission.find(params[:id])
    response = {}

    respond_to do |format|
      if new_admission.update(new_admission_params)
        new_admission.agreement.update(description:params[:description])

        response[:message] = 'Acuerdo actualizado'

      else
        response[:message] = 'Error al actualizar acuerdo'
      end
      response[:object] = new_admission
      format.json {render json: response}
    end
  end



  private

  def new_admission_params
    params.require(:new_admission).permit(:student_id)
  end


end
