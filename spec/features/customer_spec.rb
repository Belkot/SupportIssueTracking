require 'rails_helper'

feature 'Customer work' do
  background do
    Department.create(name: 'Head department')
    StatusType.create([
                        { name: "Waiting for Staff Response" },
                        { name: "Waiting for Customer" },
                        { name: "On Hold" },
                        { name: "Cancelled" },
                        { name: "Completed" }
                      ])
  end

  scenario 'adds a new ticket' do
    ticket = build(:ticket)

    visit root_path
    expect{
      fill_in 'Name', with: ticket.name
      fill_in 'Email', with: ticket.email
      select 'Head department', from: 'Department'
      fill_in 'Subject', with: ticket.subject
      fill_in 'Body', with: ticket.body

      click_button 'Create Ticket'
    }.to change(Ticket, :count).by(1)
    expect(page).to have_content 'Your ticket was saved. We sent you on email the link to the ticket'
    expect(current_path).to eq ticket_path(Ticket.first.reference)
    within 'h1' do
      expect(page).to have_content "Ticket #{Ticket.first.reference}"
    end
    expect(page).to have_content ticket.name
    expect(page).to have_content ticket.email
    expect(page).to have_content 'Head department'
    expect(page).to have_content ticket.subject
    expect(page).to have_content ticket.body

  end

  scenario 'adds a answer' do
    ticket = create(:ticket)
    answer = build(:answer)
    visit ticket_path(ticket.reference)

    expect{
      fill_in 'answer_body', with: answer.body

      click_button 'Create Answer'
    }.to change(Answer, :count).by(1)
    expect(current_path).to eq ticket_path(ticket.reference)
    expect(page).to have_content answer.body
  end
end