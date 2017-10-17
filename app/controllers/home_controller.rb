class HomeController < ApplicationController
  before_action :auth_required


  # entry point
  def index
    @agreements = Agreement.where(status: Agreement::OPEN)
  end

  def menu_items
    @meetings = Meeting.where.not(status: Meeting::DELETED)
    render layout: false
  end

  def dashboard
    render layout:false
  end

end
