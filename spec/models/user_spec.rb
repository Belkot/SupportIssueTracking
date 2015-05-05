require 'rails_helper'

RSpec.describe User, type: :model do

  it "is valid with a username, email and password" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "as admin" do
    user = build(:user)
    admin = build(:admin)
    expect(user.admin?).to be false
    expect(admin.admin?).to be true
  end

  it "as disabled" do
    user = build(:user)
    expect(user.enable?).to be true
    user.enable = false
    expect(user.enable?).to be false
  end

  context 'is invalid' do

    it "with username blank" do
      user = build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include("can't be blank")
    end

    it "with password blank" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "with a short password" do
      user = build(:user, password: '1234567')
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it "with a long password" do
      user = build(:user, password: '1'*129)
      user.valid?
      expect(user.errors[:password]).to include("is too long (maximum is 128 characters)")
    end

    it "with email blank" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end
  end

end
