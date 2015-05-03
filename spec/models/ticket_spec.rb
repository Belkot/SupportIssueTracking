require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it "is valid with a name, email, department, subject and body" do
    expect(build(:ticket)).to be_valid
  end

  context "is invalid" do

    it "without a name" do
      ticket = build(:ticket, name: nil)
      ticket.valid?
      expect(ticket.errors[:name]).to include("can't be blank")
    end

    it "without a email" do
      ticket = build(:ticket, email: nil)
      ticket.valid?
      expect(ticket.errors[:email]).to include("can't be blank")
    end

    it "without a department" do
      ticket = build(:ticket, department: nil)
      ticket.valid?
      expect(ticket.errors[:department]).to include("can't be blank")
    end

    it "without a subject" do
      ticket = build(:ticket, subject: nil)
      ticket.valid?
      expect(ticket.errors[:subject]).to include("can't be blank")
    end

    it "without a body" do
      ticket = build(:ticket, body: nil)
      ticket.valid?
      expect(ticket.errors[:body]).to include("can't be blank")
    end

    it "with a short name" do
      ticket = build(:ticket, name: 'Ab')
      ticket.valid?
      expect(ticket.errors[:name]).to include("is too short (minimum is 3 characters)")
    end

    it "with a long name" do
      long_name = 'a' * 31
      ticket = build(:ticket, name: long_name)
      ticket.valid?
      expect(ticket.errors[:name]).to include("is too long (maximum is 30 characters)")
    end

    it "when format email invalid" do
      emails = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      emails.each do |email|
        ticket = build(:ticket, email: email)
        expect(ticket).not_to be_valid
      end
    end

    it "with a long email" do
      long_name = 'a' * 110 + '18invalid@test.com'
      ticket = build(:ticket, email: long_name)
      ticket.valid?
      expect(ticket.errors[:email]).to include("is too long (maximum is 127 characters)")
    end

    it "with a short subject" do
      shot_subject = 'Abcd'
      ticket = build(:ticket, subject: shot_subject)
      ticket.valid?
      expect(ticket.errors[:subject]).to include("is too short (minimum is 5 characters)")
    end

    it "with a long subject" do
      long_subject = 'a' * 256
      ticket = build(:ticket, subject: long_subject)
      ticket.valid?
      expect(ticket.errors[:subject]).to include("is too long (maximum is 255 characters)")
    end

    it "with a short body" do
      shot_body = '14Abcdefghijkl'
      ticket = build(:ticket, body: shot_body)
      ticket.valid?
      expect(ticket.errors[:body]).to include("is too short (minimum is 15 characters)")
    end

    it "with a long body" do
      long_body = 'a' * 4001
      ticket = build(:ticket, body: long_body)
      ticket.valid?
      expect(ticket.errors[:body]).to include("is too long (maximum is 4000 characters)")
    end

  end

  it "set reference" do
    ticket = build(:ticket)
    ticket.valid?
    expect(ticket.reference).to match(/[AAA-ZZZ]\-\d{6}/)
  end

  context "search" do

    it "by reference" do
      ticket = create(:ticket)
      expect(Ticket.search(ticket.reference)).to include(ticket)
    end

    it "by subject" do
      ticket1 = create(:ticket, subject: 'Test subject')
      ticket2 = create(:ticket, subject: 'Other subject')
      ticket3 = create(:ticket, subject: 'Any other text')
      expect(Ticket.search('subj')).to include(ticket1, ticket2)
      expect(Ticket.search('subj')).not_to include(ticket3)
    end

  end

  context "get" do
    before do
      status_type_names = [ "Waiting for Staff Response",
                            "Waiting for Customer",
                            "On Hold",
                            "Cancelled",
                            "Completed"
                          ]
      status_type_names.each { |name| StatusType.create(name: name) }

      @user = create(:user)
      @ticket_waiting_for_staff_response = create(:ticket)
      Status.create(status_type: StatusType.where(name: "Waiting for Staff Response").first,
                    ticket: @ticket_waiting_for_staff_response, user: @user)
      @ticket_waiting_for_customer = create(:ticket)
      Status.create(status_type: StatusType.where(name: "Waiting for Customer").first,
                    ticket: @ticket_waiting_for_customer, user: @user)
      @ticket_onhold = create(:ticket)
      Status.create(status_type: StatusType.where(name: "On Hold").first,
                    ticket: @ticket_onhold, user: @user)
      @ticket_cancelled = create(:ticket)
      Status.create(status_type: StatusType.where(name: "Cancelled").first,
                    ticket: @ticket_cancelled, user: @user)
      @ticket_completed = create(:ticket)
      Status.create(status_type: StatusType.where(name: "Completed").first,
                    ticket: @ticket_completed, user: @user)
    end

    it "new unassigned tickets" do
      # dont have owner
      ticket_with_owner = create(:ticket)
      Owner.create(ticket: ticket_with_owner, user: @user)
      ticket_without_owner = create(:ticket)
      expect(Ticket.unassigned).not_to include(ticket_with_owner)
      expect(Ticket.unassigned).to include(ticket_without_owner)
    end


    it "open tickets" do
      # status is not 'Completed', 'Cancelled' or 'On Hold'
      expect(Ticket.open).not_to include(@ticket_onhold,
                                         @ticket_cancelled,
                                         @ticket_closed)
      expect(Ticket.open).to include(@ticket_waiting_for_staff_response,
                                     @ticket_waiting_for_customer)
    end

    it "on hold tickets" do
      # status is 'On Hold'
      expect(Ticket.onhold).not_to include(@ticket_waiting_for_customer,
                                           @ticket_waiting_for_staff_response,
                                           @ticket_completed, @ticket_cancelled)
      expect(Ticket.onhold).to include(@ticket_onhold)
    end

    it "closed tickets" do
      # status is 'Cancelled' and 'Completed'
      expect(Ticket.closed).not_to include(@ticket_waiting_for_staff_response,
                                           @ticket_waiting_for_customer,
                                           @ticket_onhold)
      expect(Ticket.closed).to include(@ticket_completed, @ticket_cancelled)
    end

  end

end
