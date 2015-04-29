require 'rails_helper'

RSpec.describe Answer, type: :model do
  it "is valid with a body and ticket_id" do
    answer = Answer.new(body: 'Test answer')
    expect(answer).to be_valid
  end

  it "is invalid without a body" do
    answer = Answer.new
    answer.valid?
    expect(answer.errors[:body]).to include("can't be blank")
  end

  it "is valid with a duplicate body" do
    Answer.create(body: 'Test 2 answer')
    answer = Answer.new(body: 'Test 2 answer')
    answer.valid?
    expect(answer).to be_valid
  end

  it "is invalid with a short body" do
    answer = Answer.new(body: 'Abcdefghi')
    answer.valid?
    expect(answer.errors[:body]).to include("is too short (minimum is 10 characters)")
  end

  it "is invalid with a long body" do
    long_name = 'a' * 4001
    answer = Answer.new(body: long_name)
    answer.valid?
    expect(answer.errors[:body]).to include("is too long (maximum is 4000 characters)")
  end
end
