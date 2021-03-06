# == Schema Information
#
# Table name: account_tokens
#
#  id            :integer         not null, primary key
#  account_token :string(255)
#  state         :string(255)
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#  label         :string(255)
#

require 'spec_helper'

describe AccountToken do
  before :each do
    @user = Factory(:user)
    @user.save
    @account_token = Factory(:account_token)
    @attr = { :label => "test", :user_id => @user.id }
  end

  describe "model associations" do
    describe "it should respond to methods" do
      it "should respond to the auth_logs method" do
        @account_token.should respond_to :auth_logs
      end

      it "should be able to create a new auth_log" do
        auth_log = @account_token.auth_logs.new
        auth_log.outcome = true
        auth_log.save!
        auth_log.account_token.should == @account_token
      end
    end
  end
  
  describe "creation" do
    it "should be valid" do
      @account_token.should be_valid  
    end
    
    it "should have the right label" do
      @account_token.label.should == "test"
    end
    
    it "should have the right state" do
      @account_token.state.should == :active
    end

    describe "token generation" do
      it "should never have an empty token" do
        @account_token.account_token.should_not be nil
      end
    end
  end
  
  describe "revokation" do
    it "should still exist" do
      @account_token.revoke
      @account_token.should_not == nil
    end
    
    it "should have the right state" do
      @account_token.revoked?.should == false
      @account_token.revoke
      @account_token.reload
      @account_token.state.should == :revoked.to_s
      @account_token.revoked?.should == true
    end
  end
  
  describe "user relation" do
    it "should have an user" do
      @account_token.should respond_to :user
    end
    
    it "should have the right user" do
      @account_token.user.should == @user
    end
  end
end



