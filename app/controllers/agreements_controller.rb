class AgreementsController < ApplicationController
  def index
    @agreements = Agreement.all
  end

  def show
    @agreement = Agreement.find(params[:id])
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

  def delete
    agreement = Agreement.find(params[:id])
    if agreement.destroy
      redirect_to agreements_index_path
    else
      render plain: 'No se pudo eliminar el acuerdo'
    end
  end

  def edit
    @agreement = Agreement.find(params[:id])
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


  private

  def agreement_params
    params.require(:agreement).permit(:meeting_id, :status, :agreement_type, :description)
  end

end
