class SynodDesignationsController < ApplicationController

  def create
    synod_designation = SynodDesignation.new(synod_designation_params)
    if synod_designation.save

      agreement = synod_designation.build_agreement
      agreement.description = params[:description]
      agreement.meeting_id = params[:meeting_id]
      if synod_designation.save
        flash[:success] = "Acuerdo creado"
      else
        flash[:error] = "Error al crear acuerdo"
        flash[:error] = agreement.errors.full_messages[0]
      end

    else
      flash[:error] = "Error al crear acuerdo"
      flash[:error] = agreement.errors.full_messages[0]

    end
    redirect_to synod_designation.agreement.meeting

  end

  def update
    synod_designation = SynodDesignation.find(params[:id])
    if synod_designation.update(synod_designation_params)
      synod_designation.agreement.update(description:params[:description])
      flash[:success] = "Acuerdo actualizado"

    else
      flash[:error] = "Error al actualizar acuerdo"
      flash[:error] = agreement.errors.full_messages[0]

    end
    redirect_to synod_designation.agreement.meeting

  end




  private

  def synod_designation_params
    params.require(:synod_designation).permit(:student_id, :synodal1, :synodal2, :synodal3, :synodal4, :synodal5)
  end



end
