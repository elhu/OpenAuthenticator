# == Schema Information
#
# Table name: sync_tokens
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  sync_token :string(255)
#  expires_at :string(255)
#  used       :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe SyncToken do
	describe "associations" do
		before :each do
			@sync_token = SyncToken.new
		end

		it "should belong to a user" do
			@sync_token.should respond_to :user
		end
	end

	describe "creation" do
		before :each do
			user = Factory(:user)
			@sync_token = user.sync_tokens.create
		end

		it "should have a proper attributes" do
			@sync_token.sync_token.should_not be nil
			@sync_token.sync_token.length.should == 8
			@sync_token.used.should == false
			@sync_token.expires_at.should == @sync_token.created_at + 10.minutes
		end
	end
end
