class DepartmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @departments = Department.all
    respond_with(@departments)
  end

  def show
    respond_with(@department)
  end

  def new
    @department = Department.new
    respond_with(@department)
  end

  def edit
  end

  def create
    @department = Department.new(department_params)
    @department.save
    respond_with(@department)
  end

  def update
    @department.update(department_params)
    respond_with(@department)
  end

  def destroy
    @department.enable = false
    flash[:notice] = "Department #{@department.name} disabled." if @department.save
    redirect_to departments_path
  end

  private
    def set_department
      @department = Department.find(params[:id])
    end

    def department_params
      params.require(:department).permit(:name, :enable)
    end
end
