require 'rails_helper'

feature 'Stuff work' do
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

  before(:each) do
    @user = create(:user)
    @ticket = create(:ticket)

    visit root_path
    fill_in 'Username', with: @user.username
    fill_in 'Password', with: @user.password
    click_button 'Log in'
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
    expect(current_path).to eq ticket_path(Ticket.last.id)
    within 'h1' do
      expect(page).to have_content "Ticket #{Ticket.last.reference}"
    end
    expect(page).to have_content ticket.name
    expect(page).to have_content ticket.email
    expect(page).to have_content 'Head department'
    expect(page).to have_content ticket.subject
    expect(page).to have_content ticket.body
  end

  scenario 'Search ticket by reference' do
    fill_in 'search', with: @ticket.reference
    click_button 'Search'
    click_link 'Show'

    expect(current_path).to eq ticket_path(@ticket.id)
    within 'h1' do
      expect(page).to have_content "Ticket #{@ticket.reference}"
    end
    expect(page).to have_content @ticket.name
    expect(page).to have_content @ticket.email
    expect(page).to have_content @ticket.department.name
    expect(page).to have_content @ticket.subject
    expect(page).to have_content @ticket.body

  end

  scenario 'Search ticket by text from subject' do
    fill_in 'search', with: @ticket.subject[0, 5]
    click_button 'Search'
    click_link 'Show'

    expect(current_path).to eq ticket_path(@ticket.id)
    within 'h1' do
      expect(page).to have_content "Ticket #{@ticket.reference}"
    end
    expect(page).to have_content @ticket.name
    expect(page).to have_content @ticket.email
    expect(page).to have_content @ticket.department.name
    expect(page).to have_content @ticket.subject
    expect(page).to have_content @ticket.body

  end

  scenario 'adds a answer' do
    answer = build(:answer)
    visit ticket_path(@ticket.id)

    expect{
      fill_in 'answer_body', with: answer.body

      click_button 'Create Answer'
    }.to change(Answer, :count).by(1)
    expect(current_path).to eq ticket_path(@ticket.id)
    expect(page).to have_content answer.body
  end

  scenario 'be owner' do
    visit ticket_path(@ticket.id)

    expect{
      click_button 'Be owner'
    }.to change(Owner, :count).by(1)
    expect(current_path).to eq ticket_path(@ticket.id)
    expect(page).to have_content @user.username
    expect(page).to_not have_content 'Be owner'
    within '#owner_history' do
      expect(page).to have_content @user.username
    end
  end

  scenario 'change status' do
    visit ticket_path(@ticket.id)

    expect{
      choose 'On Hold'
      click_button 'Update Status'
    }.to change(Status, :count).by(1)
    expect(current_path).to eq ticket_path(@ticket.id)
    within '#status_history' do
      expect(page).to have_content @user.username
      expect(page).to have_content 'On Hold'
    end
  end

end