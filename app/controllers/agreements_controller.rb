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
    if agreement.save
      redirect_to agreement
    else
      render plain: 'No se pudo crear el acuerdo'
    end
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


  private

  def agreement_params
    params.require(:agreement).permit(:meeting_id, :status, :agreement_type, :description)
  end

end
