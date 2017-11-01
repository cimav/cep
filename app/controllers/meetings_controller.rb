class MeetingsController < ApplicationController
  include AgreementsHelper

  def index
    @meetings = Meeting.all.order(date: :desc)
    render layout: false
  end

  def show
    @meeting = Meeting.find(params[:id])
    @meeting_agreements = Agreement.where(meeting_id:@meeting.id).where.not(status: Agreement::DELETED)
    # Estadísticas de acuerdos resueltos
    agreement_types = @meeting.agreement.group(:agreeable_type).count
    @agreement_type_name = ''
    @agreement_type_value = ''
    agreement_types.each do |type, count|
      @agreement_type_name +="'" + a_class_to_name(type.to_s)+ "'" + ","
      @agreement_type_value += count.to_s + ","
    end
    @agreement_type_name = @agreement_type_name[0...@agreement_type_name.length-1]
    @agreement_type_value = @agreement_type_value[0...@agreement_type_value.length-1]


    render layout: false

  end

  def new
    @meeting = Meeting.new
    render layout: false
  end

  def create
    data = {}
    data = meeting_params
    data[:date] = get_datetime(params)

    meeting = Meeting.new(data)
    meeting.status = Meeting::OPENED
    response = {}
    respond_to do |format|
      if is_admin?
        if meeting.save
          response[:message] = 'Sesión creada'
          response[:redirect_url] = "meetings/#{meeting.id}"
        else
          response[:message] = 'Error al crear sesión'
          response[:redirect_url] = "meetings/new"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end

      response[:errors] = meeting.errors.full_messages
      response[:object] = meeting
      format.json {render json: response}
    end
  end

  def destroy
    meeting = Meeting.find(params[:id])
    response = {}
    respond_to do |format|
      if is_admin?
        meeting.status = Meeting::DELETED
        if meeting.save
          response[:message] = 'Sesión eliminada'
        else
          response[:message] = 'Error al eliminar sesión'
          response[:redirect_url] = "meetings/#{meeting.id}"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
      end
      response[:redirect_url] = "home"
      response[:errors] = meeting.errors.full_messages
      format.json {render json: response}
    end
  end

  def edit
    @meeting = Meeting.find(params[:id])
    datetime = @meeting.date.to_s()
    @date = datetime.split(" ")[0].to_date.strftime("%d %B, %Y")

    @time = datetime.split(" ")[1].to_time.strftime('%l:%M%P') rescue "" #hora con formato 12H
    render layout:false
  end

  def update
    data = {}
    data = meeting_params
    data[:date] = get_datetime(params)
    meeting = Meeting.find(params[:id])
    response = {}

    respond_to do |format|
      if is_admin?
        if meeting.update(data)
          response[:message] = 'Sesión actualizada'
          response[:redirect_url] = "meetings/#{meeting.id}"
        else
          response[:message] = 'Error al actualizar sesión'
          response[:redirect_url] = "meetings/#{meeting.id}/edit"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end

      response[:object] = meeting
      format.json {render json: response}
    end
  end

  def new_agreement
    @meeting = Meeting.find(params[:id])
    render layout:false
  end


  private

  def meeting_params
    params.require(:meeting).permit(:status, :meeting_type, :date)
  end

  def get_datetime(params)
    date    = params[:date]
    time    = params[:time]
    return "#{date} #{time}"
  end

end
