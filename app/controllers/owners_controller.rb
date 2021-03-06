class OwnersController < ApplicationController
  before_action :authenticate_user!

  def create
    owner = Owner.new(ticket_id: params[:ticket_id], user_id: current_user.id)
    flash[:notice] = "You became the owner of this ticket." if owner.save
    redirect_to ticket_path(owner.ticket_id)
  end

end
