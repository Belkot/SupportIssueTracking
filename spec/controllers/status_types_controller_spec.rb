require 'rails_helper'

RSpec.describe StatusTypesController, type: :controller do

  let(:valid_attributes) { attributes_for(:status_type) }

  describe "administrator access" do

    login_admin

    let(:invalid_attributes) { attributes_for(:status_type, name: nil) }

    describe "GET #index" do
      it "assigns all status_types as @status_types" do
        status_type = StatusType.create! valid_attributes
        get :index, {}
        expect(assigns(:status_types)).to eq([status_type])
      end
    end

    describe "GET #show" do
      it "assigns the requested status_type as @status_type" do
        status_type = StatusType.create! valid_attributes
        get :show, {id: status_type.to_param}
        expect(assigns(:status_type)).to eq(status_type)
      end
    end

    describe "GET #new" do
      it "assigns a new status_type as @status_type" do
        get :new, {}
        expect(assigns(:status_type)).to be_a_new(StatusType)
      end
    end

    describe "GET #edit" do
      it "assigns the requested status_type as @status_type" do
        status_type = StatusType.create! valid_attributes
        get :edit, {id: status_type.to_param}
        expect(assigns(:status_type)).to eq(status_type)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new StatusType" do
          expect {
            post :create, {status_type: valid_attributes}
          }.to change(StatusType, :count).by(1)
        end

        it "assigns a newly created status_type as @status_type" do
          post :create, {status_type: valid_attributes}
          expect(assigns(:status_type)).to be_a(StatusType)
          expect(assigns(:status_type)).to be_persisted
        end

        it "redirects to the created status_type" do
          post :create, {status_type: valid_attributes}
          expect(response).to redirect_to(StatusType.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved status_type as @status_type" do
          post :create, {status_type: invalid_attributes}
          expect(assigns(:status_type)).to be_a_new(StatusType)
        end

        it "re-renders the 'new' template" do
          post :create, {status_type: invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) { {name: 'New status' } }

        it "updates the requested status_type" do
          status_type = StatusType.create! valid_attributes
          put :update, {id: status_type.to_param, status_type: new_attributes}
          status_type.reload
          expect(status_type.name).to eq('New status')
        end

        it "assigns the requested status_type as @status_type" do
          status_type = StatusType.create! valid_attributes
          put :update, {id: status_type.to_param, status_type: valid_attributes}
          expect(assigns(:status_type)).to eq(status_type)
        end

        it "redirects to the status_type" do
          status_type = StatusType.create! valid_attributes
          put :update, {id: status_type.to_param, status_type: valid_attributes}
          expect(response).to redirect_to(status_type)
        end
      end

      context "with invalid params" do
        it "assigns the status_type as @status_type" do
          status_type = StatusType.create! valid_attributes
          put :update, {id: status_type.to_param, status_type: invalid_attributes}
          expect(assigns(:status_type)).to eq(status_type)
        end

        it "re-renders the 'edit' template" do
          status_type = StatusType.create! valid_attributes
          put :update, {id: status_type.to_param, status_type: invalid_attributes}
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested status_type" do
        status_type = StatusType.create! valid_attributes
        expect {
          delete :destroy, {id: status_type.to_param}
        }.to change(StatusType, :count).by(-1)
      end

      it "redirects to the status_types list" do
        status_type = StatusType.create! valid_attributes
        delete :destroy, {id: status_type.to_param}
        expect(response).to redirect_to(status_types_url)
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
      status_type = StatusType.create! valid_attributes
      get :show, {id: status_type.to_param}
      expect(response).to redirect_to root_url
    end

    it "GET #new denies access" do
      get :new, {}
      expect(response).to redirect_to root_url
    end

    it "GET #edit denies access" do
      status_type = StatusType.create! valid_attributes
      get :edit, {id: status_type.to_param}
      expect(response).to redirect_to root_url
    end

    it "POST #create denies access" do
      post :create, status_type: valid_attributes
      expect(response).to redirect_to root_url
    end

    it "PUT #update denies access" do
      status_type = StatusType.create! valid_attributes
      put :update, {id: status_type.to_param, status_type: {name: 'New status'}}
      expect(response).to redirect_to root_url
    end

    it "DELETE #destroy denies access" do
      status_type = StatusType.create! valid_attributes
      delete :destroy, {id: status_type.to_param}
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
      status_type = StatusType.create! valid_attributes
      get :show, {id: status_type.to_param}
      expect(response).to redirect_to user_session_url
    end

    it "GET #new denies access" do
      get :new, {}
      expect(response).to redirect_to user_session_url
    end

    it "GET #edit denies access" do
      status_type = StatusType.create! valid_attributes
      get :edit, {id: status_type.to_param}
      expect(response).to redirect_to user_session_url
    end

    it "POST #create denies access" do
      post :create, status_type: valid_attributes
      expect(response).to redirect_to user_session_url
    end

    it "PUT #update denies access" do
      status_type = StatusType.create! valid_attributes
      put :update, {id: status_type.to_param, status_type: {name: 'New department'}}
      expect(response).to redirect_to user_session_url
    end

    it "DELETE #destroy denies access" do
      status_type = StatusType.create! valid_attributes
      delete :destroy, {id: status_type.to_param}
      expect(response).to redirect_to user_session_url
    end

  end

end
