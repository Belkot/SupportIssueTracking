require 'rails_helper'

RSpec.describe TicketsController, type: :controller do

  shared_examples "staff access to tickets" do
    #login_admin
    #login_user

    let(:valid_attributes) { attributes_for(:ticket, department_id: create(:department).id) }
    let(:invalid_attributes) { attributes_for(:ticket, email: nil) }

    describe "GET #index" do
      it "assigns all tickets as @tickets" do
        ticket = create(:ticket)
        get :index, {}
        expect(assigns(:tickets)).to eq([ticket])
      end
    end

    describe "GET #unassigned" do
      it "assigns all tickets as @tickets" do
        ticket = create(:ticket)
        get :unassigned, {}
        expect(assigns(:tickets)).to eq([ticket])
      end
    end

    describe "GET #open" do
      it "assigns all tickets as @tickets" do
        ticket = create(:ticket)
        ticket2 = create(:ticket)
        Status.create(status_type: create(:status_type, name: 'Waiting for Customer'),
                      ticket: ticket, user: create(:user))
        Status.create(status_type: create(:status_type, name: 'Completed'),
                      ticket: ticket2, user: create(:user))
        get :open, {}
        expect(assigns(:tickets)).to eq([ticket])
        expect(assigns(:tickets)).not_to eq([ticket2])
      end
    end

    describe "GET #onhold" do
      it "assigns all tickets as @tickets" do
        ticket = create(:ticket)
        Status.create(status_type: create(:status_type, name: 'On Hold'),
                      ticket: ticket, user: create(:user))
        get :onhold, {}
        expect(assigns(:tickets)).to eq([ticket])
      end
    end

    describe "GET #closed" do
      it "assigns all tickets as @tickets" do
        ticket = create(:ticket)
        Status.create(status_type: create(:status_type, name: 'Completed'),
                      ticket: ticket, user: create(:user))
        get :closed, {}
        expect(assigns(:tickets)).to eq([ticket])
      end
    end

    describe "GET #show" do
      it "assigns the requested ticket as @ticket" do
        ticket = create(:ticket)
        get :show, {id: ticket.to_param}
        expect(assigns(:ticket)).to eq(ticket)
      end
    end

    describe "GET #new" do
      it "assigns a new ticket as @ticket" do
        get :new, {}
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end
    end

    describe "GET #edit" do
      it "does not route to ticket" do
        ticket = create(:ticket)
        expect(get: ticket_url(ticket) + "/edit").not_to be_routable
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Ticket" do
          expect {
            post :create, {ticket: valid_attributes}
          }.to change(Ticket, :count).by(1)
        end

        it "assigns a newly created ticket as @ticket" do
          post :create, {ticket: valid_attributes}
          expect(assigns(:ticket)).to be_a(Ticket)
          expect(assigns(:ticket)).to be_persisted
        end

        it "redirects to the created ticket" do
          post :create, {ticket: valid_attributes}
          expect(response).to redirect_to(Ticket.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved ticket as @ticket" do
          post :create, {ticket: invalid_attributes}
          expect(assigns(:ticket)).to be_a_new(Ticket)
        end

        it "re-renders the 'new' template" do
          post :create, {ticket: invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      it "does not route to ticket" do
        ticket = create(:ticket)
        expect(put: ticket_url(ticket)).not_to be_routable
      end
    end

    describe "DELETE #destroy" do
      it "does not route to ticket" do
        ticket = create(:ticket)
        expect(delete: ticket_url(ticket)).not_to be_routable
      end
    end

  end

  describe "administrator access" do
    login_admin
    it_behaves_like "staff access to tickets"
  end

  describe "user access" do
    login_user
    it_behaves_like "staff access to tickets"
  end

  describe "guest access" do

    let(:valid_attributes) { attributes_for(:ticket, department_id: create(:department).id) }
    let(:invalid_attributes) { attributes_for(:ticket, email: nil) }

    describe "GET #index" do
      it "denies access" do
        get :index, {}
        expect(response).to redirect_to user_session_url
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end

    describe "GET #unassigned" do
      it "denies access" do
        get :unassigned, {}
        expect(response).to redirect_to user_session_url
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end

    describe "GET #open" do
      it "denies access" do
        get :open, {}
        expect(response).to redirect_to user_session_url
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end

    describe "GET #onhold" do
      it "denies access" do
        get :onhold, {}
        expect(response).to redirect_to user_session_url
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end

    describe "GET #closed" do
      it "denies access" do
        get :closed, {}
        expect(response).to redirect_to user_session_url
        expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
      end
    end

    describe "GET #show" do
      it "assigns the requested ticket as @ticket" do
        ticket = create(:ticket)
        get :show, {id: ticket.reference}
        expect(assigns(:ticket)).to eq(ticket)
      end
    end

    describe "GET #new" do
      it "assigns a new ticket as @ticket" do
        get :new, {}
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end
    end

    describe "GET #edit" do
      it "does not route to ticket" do
        ticket = create(:ticket)
        expect(get: ticket_url(ticket) + "/edit").not_to be_routable
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Ticket" do
          expect {
            post :create, {ticket: valid_attributes}
          }.to change(Ticket, :count).by(1)
        end

        it "assigns a newly created ticket as @ticket" do
          post :create, {ticket: valid_attributes}
          expect(assigns(:ticket)).to be_a(Ticket)
          expect(assigns(:ticket)).to be_persisted
        end

        it "redirects to the created ticket" do
          post :create, {ticket: valid_attributes}
          expect(response).to redirect_to(ticket_url Ticket.last.reference)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved ticket as @ticket" do
          post :create, {ticket: invalid_attributes}
          expect(assigns(:ticket)).to be_a_new(Ticket)
        end

        it "re-renders the 'new' template" do
          post :create, {ticket: invalid_attributes}
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      it "does not route to ticket" do
        ticket = create(:ticket)
        expect(put: ticket_url(ticket)).not_to be_routable
      end
    end

    describe "DELETE #destroy" do
      it "does not route to ticket" do
        ticket = create(:ticket)
        expect(delete: ticket_url(ticket)).not_to be_routable
      end
    end
  end

end
