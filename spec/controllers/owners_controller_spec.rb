require 'rails_helper'

RSpec.describe OwnersController, type: :controller do

  shared_examples "staff access to tickets" do

    let(:ticket) {create(:ticket)}

    describe "POST #create" do
      it "creates a new Owner" do
        expect {
          post :create, {ticket_id: ticket.id}
        }.to change(Owner, :count).by(1)
      end

      it "redirects to the ticket" do
        post :create, {ticket_id: ticket.id}
        expect(response).to redirect_to(ticket_path(ticket))
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

    let(:ticket) {create(:ticket)}

    describe "POST #create" do
      it "not creates a new Owner" do
        expect {
          post :create, {ticket_id: ticket.id}
        }.to change(Owner, :count).by(0)
      end

      it "redirects to the log in" do
        post :create, {ticket_id: ticket.id}
        expect(response).to redirect_to(user_session_url)
      end
    end

  end

end
