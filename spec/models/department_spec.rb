require 'rails_helper'

RSpec.describe Department, type: :model do
  it "is valid with a name" do
    department = Department.new(name: 'Test department')
    expect(department).to be_valid
  end

  it "is invalid without a name" do
    department = Department.new
    department.valid?
    expect(department.errors[:name]).to include("can't be blank")
  end

  it "invalid with a duplicate name" do
    Department.create(name: 'Test 2 department')
    department = Department.new(name: 'Test 2 department')
    department.valid?
    expect(department.errors[:name]).to include('has already been taken')
  end

  it "invalid with a short name" do
    department = Department.new(name: 'A')
    department.valid?
    expect(department.errors[:name]).to include("is too short (minimum is 2 characters)")
  end

  it "invalid with a long name" do
    long_name = 'a' * 256
    department = Department.new(name: long_name)
    department.valid?
    expect(department.errors[:name]).to include("is too long (maximum is 255 characters)")
  end
end
