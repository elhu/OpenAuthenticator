# This class defines the methods used in several controllers
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  def restricted
    response = HttpResponse.new
    response.body = false
    response.status  = :unauthorized
    if params[:auth_token].blank?
      respond response
    else
      cookie = PseudoCookie.find_by_cookie(params[:auth_token])
      auth_user = cookie.user
      if params[:user_id] != auth_user.login and params[:id] != auth_user.login and cookie.expire.to_time > Time.new
        respond response
      end
    end
  end
  
  def generate_token(personal_key)
    timespan = 30
    time = Time.new.to_i / timespan
    to_hash = "#{personal_key}--#{time.to_s}"
    token = Digest::SHA2.hexdigest(to_hash)[0..7]
  end
  
  private 
  def respond(response)
    respond_to do |format|
      format.json { render :json => response.body, :status => response.status }
      format.xml { render :xml => response.body, :status => response.status }
    end
  end
end
