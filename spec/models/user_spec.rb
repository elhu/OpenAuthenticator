# == Schema Information
#
# Table name: users
#
#  id             :integer         not null, primary key
#  login          :string(255)
#  first_name     :string(255)
#  last_name      :string(255)
#  birthdate      :date
#  email          :string(255)
#  emergency_pass :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'spec_helper'

describe User do
  before :each do
      @attr = { :login => "login",
      :first_name => "first_name",
      :last_name => "last_name",
      :email => "email@example.com",
      :emergency_pass => "pass" }
  end

  describe "creation" do
    describe "success" do
      it "should create a user given correct parameters" do
        @user = User.create(@attr)
      end
    end
  end

  describe "personalKey association" do
    before :each do
      @user = User.create @attr
    end

    it "should have a personal_keys method" do
      @user.should respond_to :personal_keys
    end

    it "should have a account_token method" do
      @user.should respond_to :account_tokens
    end
  end
end

