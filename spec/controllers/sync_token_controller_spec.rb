require 'spec_helper'

describe SyncTokenController do
  render_views
  before :each do
    @user = Factory(:user)
    @user.save
  end

	describe "GET 'account_sync'" do
  	describe "Authentication error" do
      it "should have a 401 status code" do
        get :account_sync, :format => :json, :user_id => @user.login, :id => 42
        response.status.should == 401
      end
  	end

  	describe "Authentication success" do
      before :each do
        user_id = 1
        @cookie = PseudoCookie.new
        @cookie.user_id = user_id
        @cookie.expire = Time.new + (10 * 60)
        @cookie.cookie = Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}") + user_id.to_s
        @cookie.save!
        @sync_token = Factory(:sync_token)
        @sync_token.save
      end

      describe "success" do
       	it "should succeed" do
	    		get :account_sync, :format => :json, :user_id => @user.login, :id => @sync_token.id, :auth_token => @cookie.cookie
	    		response.status.should == 200
	    	end

	    	it "should contain the sync data" do
	    		get :account_sync, :format => :json, :user_id => @user.login, :id => @sync_token.id, :auth_token => @cookie.cookie
	    		res = ActiveSupport::JSON.decode response.body
	    		res[0].should contain "user"
	    		res[1].should contain "personal_key"
	     	end

	     	it "should render the sync_token invalid" do
	     		get :account_sync, :format => :json, :user_id => @user.login, :id => @sync_token.id, :auth_token => @cookie.cookie
	     		@sync_token.reload.used.should == true
	     	end
	    end

	    describe 'failure' do
	    	it "should fail" do
	    		get :account_sync, :format => :json, :user_id => @user.login, :id => @sync_token.id + 42, :auth_token => @cookie.cookie
	    		response.status.should == 422
	    		response.body.should contain "false"
	    	end
	    end
  	end
	end

	describe "POST 'create'" do
  	describe "Authentication error" do
      it "should have a 401 status code" do
        post :create, :format => :json, :user_id => @user.login, :id => 42
        response.status.should == 401
      end
  	end

  	describe "Authentication success" do
      before :each do
        user_id = 1
        @cookie = PseudoCookie.new
        @cookie.user_id = user_id
        @cookie.expire = Time.new + (10 * 60)
        @cookie.cookie = Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}") + user_id.to_s
        @cookie.save!
      end

	  	describe "success" do
	  		it "should create a new sync_token" do
		  		post :create, :format => :json, :user_id => @user.login, :auth_token => @cookie.cookie
		  		response.status.should == 201
		  		response.body.should contain "sync_token"
		  	end
	  	end
  	end
  end
end