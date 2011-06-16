# == Schema Information
#
# Table name: personal_keys
#
#  id           :integer         not null, primary key
#  personal_key :string(255)
#  state        :string(255)
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe PersonalKey do
  before :each do
    @user = Factory(:user)
    @user.save
    @personal_key = @user.personal_key
  end
  
  describe "creation" do
    it "should exist" do
      @personal_key.should_not be nil
    end
    
    it "should have a user method" do
      @personal_key.should respond_to :user
    end
    
    it "should have the right user" do
      @personal_key.user.should == @user
    end
    
    it "should have a personal_key" do
      @personal_key.personal_key.should_not be nil	
    end
    
    it "should have the right state" do
      @personal_key.state.should == :active.to_s
    end
  end
  
  describe "revokation" do
    before :each do
      @personal_key.revoke
    end

    it "should have the right state" do
      @personal_key.state.should == :revoked
    end
  end
end


