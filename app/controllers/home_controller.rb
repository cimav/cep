class HomeController < ApplicationController
  before_action :auth_required

  def index

  end

  def menu_items
    @meetings = Meeting.where.not(status: Meeting::DELETED)
    render layout: false
  end

  def home
    @agreements = Agreement.where(status: Agreement::OPEN)
  end
end
