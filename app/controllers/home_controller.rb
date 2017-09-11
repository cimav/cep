class HomeController < ApplicationController
  before_action :auth_required

  def index

    if is_admin?
      render template: 'home/cep_index'
    else
      @agreements = Agreement.where(status: Agreement::OPEN)
      render template: 'home/cep_index'
    end
  end

  def menu_items
    render layout:false
  end
end
