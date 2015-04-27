class TicketsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :new, :create]

  respond_to :html

  def unassigned
    @tickets = paginate Ticket.unassigned
    render 'index'
  end

  def open
    @tickets = paginate Ticket.open
    render 'index'
  end

  def onhold
    @tickets = paginate Ticket.onhold
    render 'index'
  end

  def closed
    @tickets = paginate Ticket.closed
    render 'index'
  end

  def index
    if params[:search]
      @tickets = paginate Ticket.search(params[:search])
    else
      @tickets = paginate Ticket.all
    end
    respond_with(@tickets)
  end

  def show
    if user_signed_in?
      @ticket = Ticket.find_by id: params[:id]
    else
      @ticket = Ticket.find_by reference: params[:id]
    end
    @ticket ? respond_with(@ticket) : render(file: "public/404.html", status: 404)
  end

  def new
    @ticket = Ticket.new
    respond_with(@ticket)
  end

  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      flash[:notice] = "Your ticket was saved. We sent you on email the link to the ticket."
      TicketNotifier.received(@ticket).deliver
      user_signed_in? ? respond_with(@ticket) : redirect_to(action: "show", id: @ticket.reference)
    else
      respond_with(@ticket)
    end
  end

  private

    def paginate(obj, per=25)
      if obj.is_a? Array
        Kaminari.paginate_array(obj).page(params[:page]).per(per)
      else
        obj.page params[:page]
      end
    end

    def ticket_params
      params.require(:ticket).permit(:name, :email, :department_id, :reference, :subject, :body)
    end
end
