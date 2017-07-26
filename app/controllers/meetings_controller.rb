class MeetingsController < ApplicationController
  def index
    @meetings = Meeting.all.order(date: :desc)

  end

  def show
    @agreement_new = Agreement.new
    @meeting = Meeting.find(params[:id])
    datetime = @meeting.date.to_s()
    @date = datetime.split(" ")[0].to_date.strftime("%d %B, %Y")

    @time = datetime.split(" ")[1].to_time.strftime('%l:%M%P') rescue "" #hora con formato 12H

  end

  def new
    @meeting = Meeting.new
  end

  def create
    data = {}
    data = meeting_params
    data[:date] = get_datetime(params)

    meeting = Meeting.new(data)
    meeting.status = Meeting::OPENED
    if meeting.save
      redirect_to meeting
    else
      render plain: 'No se pudo crear la reunión'
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
  end



  private

  def meeting_params
    params.require(:meeting).permit(:status, :meeting_type, :date)
  end

  def get_datetime(params)
    date    = params[:meeting][:date]
    time    = params[:time]
    return "#{date} #{time}"
  end

end
