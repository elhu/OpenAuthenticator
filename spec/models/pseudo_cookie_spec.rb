# == Schema Information
#
# Table name: pseudo_cookies
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  cookie     :string(255)
#  expire     :datetime
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe PseudoCookie do
  describe "generate_cookie" do
    describe "failure" do
      it "should require a user id" do
        lambda { PseudoCookie.generate_cookie nil }.should raise_error
      end
      
      it "should not work with an unknown user id" do
        lambda { PseudoCookie.generate_cookie 42 }.should raise_error
      end
    end
    
    describe "success" do
      before :each do
        @user = Factory(:user)
        @user.save
      end
      it "should require a user id" do
        lambda { PseudoCookie.generate_cookie @user.id }.should_not raise_error
      end
    end
  end
end

