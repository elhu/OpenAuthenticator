require 'spec_helper'

describe AuthLogController do
  render_views

  before :each do
	  @user = Factory(:user)
	  @account_token = Factory(:account_token)
	  @auth_log = Factory(:auth_log)
	  @user.save
	  @account_token.save
	  @auth_log.save
	  @auth_log_2 = Factory(:auth_log)
	  @auth_log_2.outcome = true
	  @auth_log_2.save
  end

  describe "GET 'index'" do
  	describe "incorrect authentication" do
  		it "should fail with a 401 status code" do
		  	get :index, :format => :json, :user_id => @user.id
		  	response.status.should == 401
		  	response.body.should contain "false"
		  end
	  end

	  describe "correct authentication" do
	  	before :each do
        user_id = 1
        @cookie = PseudoCookie.new
        @cookie.user_id = user_id
        @cookie.expire = Time.new + (10 * 60)
        @cookie.cookie = Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}") + user_id.to_s
        @cookie.save!
	  	end

	  	it "should succeed with a 200 status code" do
	  		get :index, :format => :json, :user_id => @user.login, :auth_token => @cookie.cookie
		  	response.status.should == 200
		  end

		  it "should paginate" do
	  		get :index, :format => :json, :user_id => @user.login, :auth_token => @cookie.cookie, :page => 2
	  		response.status.should == 200
	  		response.body.should == "[]"
		  end

		  it "should have the right order" do
	  		get :index, :format => :json, :user_id => @user.login, :auth_token => @cookie.cookie
	  		response.status.should == 200
	  		ret = ActiveSupport::JSON.decode response.body
	  		ret[0].should contain "true"
	  		ret[1].should contain "false"
			  end
	  end
  end
end