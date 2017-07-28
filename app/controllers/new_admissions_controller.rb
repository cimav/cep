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
      flash[:error] = agreement.errors.full_messages[0]

    end
    redirect_to new_admission.agreement.meeting

  end

  def update
    new_admission = NewAdmission.find(params[:id])
    if new_admission.update(new_admission_params)
      new_admission.agreement.update(description:params[:description])
      flash[:success] = "Acuerdo actualizado"

    else
      flash[:error] = "Error al actualizar acuerdo"
      flash[:error] = agreement.errors.full_messages[0]

    end
    redirect_to new_admission.agreement.meeting

  end




  private

  def new_admission_params
    params.require(:new_admission).permit(:student_id)
  end


end
