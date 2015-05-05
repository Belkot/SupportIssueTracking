require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  shared_examples "staff access to tickets" do

    let(:ticket) {create(:ticket)}
    let(:valid_attributes) { attributes_for(:answer) }
    let(:invalid_attributes) { attributes_for(:answer, body: nil) }

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Answer" do
          expect {
            post :create, {answer: valid_attributes, ticket_id: ticket.id}
          }.to change(Answer, :count).by(1)
        end

        it "redirects to the created answer" do
          post :create, {answer: valid_attributes, ticket_id: ticket.id}
          expect(response).to redirect_to(ticket_path(ticket))
        end
      end

      context "with invalid params" do
        it "redirects to the show ticket" do
          post :create, {answer: invalid_attributes, ticket_id: ticket.id}
          expect(response).to redirect_to(ticket_path(ticket))
        end
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
    let(:valid_attributes) { attributes_for(:answer) }
    let(:invalid_attributes) { attributes_for(:answer, body: nil) }

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Answer" do
          expect {
            post :create, {answer: valid_attributes, ticket_id: ticket.id}
          }.to change(Answer, :count).by(1)
        end

        it "redirects to the created answer" do
          post :create, {answer: valid_attributes, ticket_id: ticket.id}
          expect(response).to redirect_to(ticket_path(ticket.reference))
        end
      end

      context "with invalid params" do
        it "redirects to the show ticket" do
          post :create, {answer: invalid_attributes, ticket_id: ticket.id}
          expect(response).to redirect_to(ticket_path(ticket.reference))
        end
      end
    end

  end

end
