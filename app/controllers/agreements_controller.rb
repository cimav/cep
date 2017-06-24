class AgreementsController < ApplicationController
  def index
    @agreements = Agreement.all
  end

  def show
    @agreement = Agreement.find(params[:id])
    @hola = params[:hola]
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
  def update
    agreement = Agreement.find(params[:id])
    respond_to do |format|
    if agreement.update(agreement_params)
      format.json {render json: agreement}
    end
    end

  end


  private

  def agreement_params
    params.require(:agreement).permit(:meeting_id, :status, :agreement_type, :description)
  end

end
