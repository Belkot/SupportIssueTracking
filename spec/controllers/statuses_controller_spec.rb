require 'rails_helper'

RSpec.describe StatusesController, type: :controller do

  before do
    @status_type = create(:status_type)
    @ticket = create(:ticket)
  end

  shared_examples "staff access to tickets" do

    describe "POST #create" do
      it "creates a new Status" do
        expect {
          post :create, {status: {status_type_id: @status_type.id}, ticket_id: @ticket.id}
        }.to change(Status, :count).by(1)
      end

      it "redirects to the ticket" do
        post :create, {status: {status_type_id: @status_type.id}, ticket_id: @ticket.id}
        expect(response).to redirect_to(ticket_path(@ticket))
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

    describe "POST #create" do
      it "not creates a new Status" do
        expect {
          post :create, {status: {status_type_id: @status_type.id}, ticket_id: @ticket.id}
        }.to change(Owner, :count).by(0)
      end

      it "redirects to the log in" do
        post :create, {status: {status_type_id: @status_type.id}, ticket_id: @ticket.id}
        expect(response).to redirect_to(user_session_url)
      end
    end

  end

end
