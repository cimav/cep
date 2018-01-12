class HomeController < ApplicationController
  before_action :auth_required


  # entry point
  def index
    @agreements = Agreement.where(status: Agreement::OPEN)
  end

  def menu_items
    @meetings = Meeting.where.not(status: Meeting::DELETED).order("date DESC")
    render layout: false
  end

  def dashboard
    @next_meeting = Meeting.where("date > ?", DateTime.now).order("date ASC").first
    render layout:false
  end

end
