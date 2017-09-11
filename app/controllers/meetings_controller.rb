class MeetingsController < ApplicationController
  def index
    @meetings = Meeting.all.order(date: :desc)
    render layout: false
  end

  def show
    @agreement_new = Agreement.new
    @meeting = Meeting.find(params[:id])
    datetime = @meeting.date.to_s()
    @date = datetime.split(" ")[0].to_date.strftime("%d %B, %Y")

    @time = datetime.split(" ")[1].to_time.strftime('%l:%M%P') rescue "" #hora con formato 12H
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
      if meeting.save
        response[:message] = 'Sesión actualizada'
        response[:redirect_url] = "meetings/#{meeting.id}"
      else
        response[:message] = 'Error al crear sesión'
        response[:redirect_url] = "meetings/new"
      end
      response[:object] = meeting
      format.json {render json: response}
    end
  end

  def delete
    meeting = Meeting.find(params[:id])
    if meeting.destroy
      redirect_to meetings_index_path
    else
      render plain: 'No se pudo eliminar la reunión'
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
      if meeting.update(data)
        response[:message] = 'Sesión actualizada'
        response[:redirect_url] = "meetings/#{meeting.id}"
      else
        response[:message] = 'Error al actualizar sesión'
        response[:redirect_url] = "meetings/#{meeting.id}/edit"
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
