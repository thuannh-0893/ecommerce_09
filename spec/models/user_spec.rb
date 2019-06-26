require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) {FactoryBot.create :user}

  subject {user}

  it "has a valid factory" do
    is_expected.to be_valid
  end

  it "is a User" do
    is_expected.to be_a_kind_of User
  end

  describe "associations" do
    it "has many orders" do
      is_expected.to have_many(:orders).dependent :destroy
    end

    it "has many products" do
      is_expected.to have_many :products
    end

    it "has many history views" do
      is_expected.to have_many(:history_views).dependent :destroy
    end

    it "has many rates" do
      is_expected.to have_many(:rates).dependent :destroy
    end

    it "has many comments" do
      is_expected.to have_many(:comments).dependent :destroy
    end
  end

  describe "name" do
    it {is_expected.to validate_presence_of :name}
    it do
      is_expected.to validate_length_of(:name).is_at_most(
        Settings.user.name.max_length)
    end
  end

  describe "email" do
    it {is_expected.to validate_presence_of :email}
    it {is_expected.to validate_uniqueness_of(:email).case_insensitive}
    it do
      is_expected.to validate_length_of(:email).is_at_most(
        Settings.user.email.max_length)
    end
    it "is invalid email" do
      user.email = "example"
      is_expected.not_to be_valid
    end
    it do
      expect(user.errors.messages[:email]).equal?(
        I18n.t "activerecord.errors.models.user.email.invalid")
    end
  end
end
