require 'rails_helper'

RSpec.describe StatusType, type: :model do
  it "is valid with a name" do
    status_type = StatusType.new(name: 'Test status type')
    expect(status_type).to be_valid
  end

  it "is invalid without a name" do
    status_type = StatusType.new
    status_type.valid?
    expect(status_type.errors[:name]).to include("can't be blank")
  end

  it "invalid with a duplicate name" do
    StatusType.create(name: 'Test 2 status type')
    status_type = StatusType.new(name: 'Test 2 status type')
    status_type.valid?
    expect(status_type.errors[:name]).to include('has already been taken')
  end

  it "invalid with a short name" do
    status_type = StatusType.new(name: 'A')
    status_type.valid?
    expect(status_type.errors[:name]).to include("is too short (minimum is 2 characters)")
  end

  it "invalid with a long name" do
    long_name = 'a' * 256
    status_type = StatusType.new(name: long_name)
    status_type.valid?
    expect(status_type.errors[:name]).to include("is too long (maximum is 255 characters)")
  end
end
