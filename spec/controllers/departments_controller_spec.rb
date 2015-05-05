require 'rails_helper'

RSpec.describe DepartmentsController, type: :controller do

  let(:valid_attributes) { attributes_for(:department) }

  describe "administrator access" do

    login_admin

    let(:invalid_attributes) { attributes_for(:department, name: nil) }

    describe "GET #index" do
      it "assigns all departments as @departments" do
        department = Department.create! valid_attributes
        get :index, {}
        expect(assigns(:departments)).to eq([department])
      end
    end

    describe "GET #show" do
      it "assigns the requested department as @department" do
        department = Department.create! valid_attributes
        get :show, {id: department.to_param}
        expect(assigns(:department)).to eq(department)
      end
    end

    describe "GET #new" do
      it "assigns a new department as @department" do
        get :new, {}
        expect(assigns(:department)).to be_a_new(Department)
      end
    end

    describe "GET #edit" do
      it "assigns the requested department as @department" do
        department = Department.create! valid_attributes
        get :edit, {id: department.to_param}
        expect(assigns(:department)).to eq(department)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Department" do
          expect {
            post :create, {department: valid_attributes}
          }.to change(Department, :count).by(1)
        end

        it "assigns a newly created department as @department" do
          post :create, {department: valid_attributes}
          expect(assigns(:department)).to be_a(Department)
          expect(assigns(:department)).to be_persisted
        end

        it "redirects to the created department" do
          post :create, {department: valid_attributes}
          expect(response).to redirect_to(Department.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved department as @department" do
          post :create, {department: invalid_attributes}
          expect(assigns(:department)).to be_a_new(Department)
        end

        it "re-renders the 'new' template" do
          post :create, {department: invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { {name: 'New department'} }

        it "updates the requested department" do
          department = Department.create! valid_attributes
          put :update, {id: department.to_param, department: new_attributes}
          department.reload
          expect(department.name).to eq('New department')
        end

        it "assigns the requested department as @department" do
          department = Department.create! valid_attributes
          put :update, {id: department.to_param, department: valid_attributes}
          expect(assigns(:department)).to eq(department)
        end

        it "redirects to the department" do
          department = Department.create! valid_attributes
          put :update, {id: department.to_param, department: valid_attributes}
          expect(response).to redirect_to(department)
        end
      end

      context "with invalid params" do
        it "assigns the department as @department" do
          department = Department.create! valid_attributes
          put :update, {id: department.to_param, department: invalid_attributes}
          expect(assigns(:department)).to eq(department)
        end

        it "re-renders the 'edit' template" do
          department = Department.create! valid_attributes
          put :update, {id: department.to_param, department: invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested department" do
        department = Department.create! valid_attributes
        expect {
          delete :destroy, {id: department.to_param}
        }.to change(Department, :count).by(0)
      end

      it "redirects to the departments list" do
        department = Department.create! valid_attributes
        delete :destroy, {id: department.to_param}
        expect(response).to redirect_to(departments_url)
      end
    end
  end

  describe "user access" do

    login_user

    after(:each) do
      expect(flash[:alert]).to eq("Admins only!")
    end

    it "GET #index denies access" do
      get :index
      expect(response).to redirect_to root_url
    end

    it "GET #show denies access" do
      department = Department.create! valid_attributes
      get :show, {id: department.to_param}
      expect(response).to redirect_to root_url
    end

    it "GET #new denies access" do
      get :new, {}
      expect(response).to redirect_to root_url
    end

    it "GET #edit denies access" do
      department = Department.create! valid_attributes
      get :edit, {id: department.to_param}
      expect(response).to redirect_to root_url
    end

    it "POST #create denies access" do
      post :create, department: valid_attributes
      expect(response).to redirect_to root_url
    end

    it "PUT #update denies access" do
      department = Department.create! valid_attributes
      put :update, {id: department.to_param, department: {name: 'New department'}}
      expect(response).to redirect_to root_url
    end

    it "DELETE #destroy denies access" do
      department = Department.create! valid_attributes
      delete :destroy, {id: department.to_param}
      expect(response).to redirect_to root_url
    end

  end

  describe "guest access" do

    after(:each) do
      expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
    end

    it "GET #index denies access" do
      get :index
      expect(response).to redirect_to user_session_url
    end

    it "GET #show denies access" do
      department = Department.create! valid_attributes
      get :show, {id: department.to_param}
      expect(response).to redirect_to user_session_url
    end

    it "GET #new denies access" do
      get :new, {}
      expect(response).to redirect_to user_session_url
    end

    it "GET #edit denies access" do
      department = Department.create! valid_attributes
      get :edit, {id: department.to_param}
      expect(response).to redirect_to user_session_url
    end

    it "POST #create denies access" do
      post :create, department: valid_attributes
      expect(response).to redirect_to user_session_url
    end

    it "PUT #update denies access" do
      department = Department.create! valid_attributes
      put :update, {id: department.to_param, department: {name: 'New department'}}
      expect(response).to redirect_to user_session_url
    end

    it "DELETE #destroy denies access" do
      department = Department.create! valid_attributes
      delete :destroy, {id: department.to_param}
      expect(response).to redirect_to user_session_url
    end

  end

end
