class StatusesController < ApplicationController

  def create
    status = Status.new(status_params)
    status.ticket_id = params[:ticket_id]
    status.user_id = current_user.id
    flash[:notice] = "Ticket status was updated on #{status.status_type.name}." if status.save
    redirect_to ticket_path(status.ticket_id)
  end

  private

    def status_params
      params.require(:status).permit(:status_type_id)
    end

end
