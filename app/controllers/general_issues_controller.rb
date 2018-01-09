class GeneralIssuesController < ApplicationController
  before_action :auth_required

  def create
    general_issue = GeneralIssue.new(general_issue_params)
    response = {}

    respond_to do |format|
      if is_admin?
        if general_issue.save

          agreement = general_issue.build_agreement
          agreement.notes = params[:notes]
          agreement.meeting_id = params[:meeting_id]
          if general_issue.save
            response[:message] = "Acuerdo creado"
            response[:redirect_url] = "agreements/#{agreement.id}"
          else
            response[:message] = "Error al registrar asunto general"
            response[:redirect_url] = "meetings/#{agreement.meeting_id}/general_issues/new"
          end

        else
          response[:message] = "Error al crear acuerdo"
          response[:errors] = general_issue.errors.full_messages
          response[:redirect_url] = "meetings/#{params[:meeting_id]}/general_issues/new"

        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end
      format.json {render json: response}
    end
  end

  def update
    general_issue = GeneralIssue.find(params[:id])
    response = {}

    respond_to do |format|
      if is_admin?
        if general_issue.update(general_issue_params)
          general_issue.agreement.update(notes:params[:notes])

          response[:message] = 'Acuerdo actualizado'
          response[:redirect_url] = "agreements/#{general_issue.agreement.id}"

        else
          response[:message] = 'Error al actualizar acuerdo'
          response[:redirect_url] = "agreements/#{general_issue.agreement.id}"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end

      response[:object] = general_issue
      format.json {render json: response}
    end
  end

  def new
    @meeting_id = params[:meeting_id]
    @general_issue = GeneralIssue.new
    render layout:false
  end




  private

  def general_issue_params
    params.require(:general_issue).permit(:subject)
  end
end
