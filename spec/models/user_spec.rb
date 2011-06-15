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
      @user = Factory(:user)
      @attr = {
        :first_name => "Foo",
        :last_name => "Bar",
        :login => "foobar",
        :email => "foo@bar.com"
      }
  end
  
  describe "creation" do
    describe "success" do
      it "should create a user given correct parameters" do
        @user.should be_valid
        user = @user.save
      end
    end
    
    describe "failure" do
      it "should require a login" do
        @user.login = nil
        @user.should_not be_valid
      end

      it "should require a first_name" do
        @user.first_name = nil
        @user.should_not be_valid
      end
      
      it "should require a last_name" do
        @user.last_name = nil
        @user.should_not be_valid
      end

      it "should require an email" do
        @user.email = nil
        @user.should_not be_valid
      end

      it "should require refuse duplicate logins" do
        @user.save
        user = User.create(@attr)
        user.should_not be_valid
      end

      it "should require refuse duplicate emails" do
        @user.save
        user = User.create(@attr)
        user.should_not be_valid
      end
      
      it "should refuse invalid emails" do
        @user.email = "test_at_example_dot_com"
        @user.should_not be_valid
      end
    end
  end
end

