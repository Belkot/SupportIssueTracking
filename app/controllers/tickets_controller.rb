class TicketsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :new, :create]
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @tickets = Ticket.all
    respond_with(@tickets)
  end

  def show
    if @ticket
      respond_with(@ticket)
    else
      render file: "public/404.html", status: 404
    end
  end

  def new
    @ticket = Ticket.new
    respond_with(@ticket)
  end

  def edit
  end

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      flash[:notice] = "Your ticket was saved. We sent you on email the link to the ticket."
      user_signed_in? ? respond_with(@ticket) : redirect_to(action: "show", id: @ticket.reference)
    else
      respond_with(@ticket)
    end
  end

  def update
    @ticket.update(ticket_params)
    respond_with(@ticket)
  end

  def destroy
    @ticket.destroy
    respond_with(@ticket)
  end

  private
    def set_ticket
      if user_signed_in?
        @ticket = Ticket.find(params[:id])
      else
        @ticket = Ticket.find_by reference: params[:id]
        #params[:id] = @ticket.id
      end
    end

    def ticket_params
      params.require(:ticket).permit(:name, :email, :department_id, :reference, :subject, :body)
    end
end
