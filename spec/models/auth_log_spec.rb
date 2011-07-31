# == Schema Information
#
# Table name: auth_logs
#
#  id            :integer         not null, primary key
#  account_token :integer
#  outcome       :boolean
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe AuthLog do
	describe "Model associations" do
		describe "respond to methods" do
			before :each do
				@auth_log = AuthLog.new
			end

			it "should respond to the account_token method" do
				@auth_log.should respond_to :account_token
			end
		end

		describe "correct_associations" do
			before :each do
				@user = Factory(:user)
				@user.save
				@account_token = Factory(:account_token)
				@account_token.save
				@auth_log = Factory(:auth_log)
				@auth_log.save
			end

			it "should have the right account_token" do
				@auth_log.account_token.should == @account_token
			end
		end
	end
end
