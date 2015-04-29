require 'rails_helper'

RSpec.describe Status, type: :model do
  it "set waiting for staff response" do
    status = Status.create(
      status_type_id: StatusType.where.not(name: "Waiting for Staff Response").first,
      user_id: 1,
      ticket_id: 1
    )
    ticket = Ticket.create()
    status.set_waiting_for_staff_response(ticket)
    expect(status.status_type_id).to eq(StatusType.where(name: "Waiting for Staff Response").first)
    expect(status.user_id).to be_nil
  end
end
