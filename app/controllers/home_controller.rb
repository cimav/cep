class HomeController < ApplicationController
  before_action :auth_required

  def index

    if is_admin?
      redirect_to meetings_path
    else
      @agreements = Agreement.where(status: Agreement::OPEN)
      render template: 'home/cep_index'
    end
  end
end
