class StatusesController < ApplicationController
  before_action :authenticate_user!

  def create
    status = Status.new(status_params)
    flash[:notice] = "Ticket status was updated on #{status.status_type.name}." if status.save
    redirect_to ticket_path(status.ticket_id)
  end

  private

    def status_params
      params.require(:status).permit(:status_type_id)
        .merge( {ticket_id: params[:ticket_id], user_id: current_user.id} )
    end

end
