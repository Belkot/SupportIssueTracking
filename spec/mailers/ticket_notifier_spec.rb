require "rails_helper"

RSpec.describe TicketNotifier, type: :mailer do
  describe "received" do
    let(:ticket) {create(:ticket) }
    let(:mail) { TicketNotifier.received(ticket) }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirming your request with unique reference.")
      expect(mail.to).to eq([ticket.email])
      expect(mail.from).to eq(["testrubyonrailsmailer@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("This is a notification that ticket #{ticket.reference} was created on your behalf.")
    end
  end

  describe "answer_received" do
    let(:user) { create(:user) }
    let(:ticket) { create(:ticket) }
    let(:answer) {create(:answer, ticket_id: ticket.id, user_id: user.id) }
    let(:mail) { TicketNotifier.answer_received(answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer for your ticket.")
      expect(mail.to).to eq([answer.ticket.email])
      expect(mail.from).to eq(["testrubyonrailsmailer@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("The #{answer.user.username} wrote:\r\n#{answer.body}")
    end
  end

end
