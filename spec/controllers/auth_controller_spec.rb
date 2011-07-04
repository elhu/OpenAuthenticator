require 'spec_helper'

describe AuthController do
  render_views
  
  describe "POST 'authenticate'" do
    before :each do
      user = Factory(:user)
      account_token = Factory(:account_token)
      user.save
      account_token.save
      @p_key = PersonalKey.current.find_by_user_id(user.id)
      @credentials = { :account_token => account_token.account_token }
    end
    
    it "should fail" do
      @credentials[:token] = "42"
      post :authenticate, :format => :json, :credentials => @credentials
      response.status.should == 401
      response.should contain "false"
    end
    
    it "should succeed" do
      timespan = 30
      time = Time.new.to_i / timespan
      to_hash = "#{@p_key.personal_key}--#{time.to_s}"
      key = Digest::SHA2.hexdigest(to_hash)[0..7]
      @credentials[:token] = key
      post :authenticate, :format => :json, :credentials => @credentials
      response.status.should == 200
      response.should contain "true"
    end
  end
  
  describe "GET 'sync'" do
    it "should always succeed" do
      get :sync, :format => :json
      response.body.to_i.should <= Time.new.to_i
    end
  end
  
  describe "POST 'session_auth'" do
    before :each do
      user = Factory(:user)
      user.save
      @p_key = PersonalKey.current.find_by_user_id(user.id)
      @credentials = { :personal_key => @p_key.personal_key }
    end
    
    it "should fail" do
      @credentials[:token] = "42"
      post :session_auth, :format => :json, :credentials => @credentials
      response.status.should == 401
      response.should contain "false"
    end
    
    it "should succeed" do
      timespan = 30
      time = Time.new.to_i / timespan
      to_hash = "#{@p_key.personal_key}--#{time.to_s}"
      key = Digest::SHA2.hexdigest(to_hash)[0..7]
      @credentials[:token] = key
      post :session_auth, :format => :json, :credentials => @credentials
      response.status.should == 200
    end

    it "should replace cookie if authenticated twice" do
      timespan = 30
      time = Time.new.to_i / timespan
      to_hash = "#{@p_key.personal_key}--#{time.to_s}"
      key = Digest::SHA2.hexdigest(to_hash)[0..7]
      @credentials[:token] = key
      post :session_auth, :format => :json, :credentials => @credentials
      response_1 = response.body
      lambda do
        post :session_auth, :format => :json, :credentials => @credentials
      end.should change(PseudoCookie, :count).by(0)
      response.status.should == 200
      response.body.should_not == response_1
    end
  end
end
