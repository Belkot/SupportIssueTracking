class StatusTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_status_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @status_types = StatusType.all
    respond_with(@status_types)
  end

  def show
    respond_with(@status_type)
  end

  def new
    @status_type = StatusType.new
    respond_with(@status_type)
  end

  def edit
  end

  def create
    @status_type = StatusType.new(status_type_params)
    @status_type.save
    respond_with(@status_type)
  end

  def update
    @status_type.update(status_type_params)
    respond_with(@status_type)
  end

  def destroy
    @status_type.destroy
    respond_with(@status_type)
  end

  private
    def set_status_type
      @status_type = StatusType.find(params[:id])
    end

    def status_type_params
      params.require(:status_type).permit(:name)
    end
end
