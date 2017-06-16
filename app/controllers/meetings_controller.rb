class MeetingsController < ApplicationController
  def index
    @meetings = Meeting.all
  end

  def show
    @meeting = Meeting.find(params[:id])
  end

  def new
    @meeting = Meeting.new
  end

  def create
    meeting = Meeting.new(meeting_params)
    if meeting.save
      redirect_to meeting
    else
      render plain: 'No se pudo crear el acuerdo'
    end
  end

  def delete
    meeting = Meeting.find(params[:id])
    if meeting.destroy
      redirect_to meetings_index_path
    else
      render plain: 'No se pudo eliminar el acuerdo'
    end
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end


  private

  def meeting_params
    params.require(:meeting).permit(:status, :meeting_type, :date)
  end

end
