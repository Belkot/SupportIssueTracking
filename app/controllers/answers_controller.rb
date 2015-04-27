class AnswersController < ApplicationController

  def create
    answer = Answer.new(answer_params)
    answer.ticket_id = params[:ticket_id]
    if user_signed_in?
      answer.user_id = current_user.id
      if answer.save
        flash[:notice] = "Answer be e-mailed to the client."
        TicketNotifier.answer_received(answer).deliver
      end
      redirect_to ticket_path(answer.ticket_id)
    else
      answer.user_id = nil
      answer.save
      Status.new.set_waiting_for_staff_response Ticket.find(params[:ticket_id])
      redirect_to ticket_path(Ticket.find(params[:ticket_id]).reference)
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
end
