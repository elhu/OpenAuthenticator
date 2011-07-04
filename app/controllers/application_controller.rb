class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  def restricted
    if params[:auth_token].blank?
      respond_to do |format|
        format.json { render :json => false, :status => :unauthorized }
      end
    else
      auth_user = PseudoCookie.find_by_cookie(params[:auth_token]).user
      if params[:user_id] != auth_user.login and params[:id] != auth_user.login
        respond_to do |format|
          format.json { render :json => false, :status => :unauthorized }
        end
      end
    end
  end
  
  def generate_token(personal_key)
    timespan = 30
    time = Time.new.to_i / timespan
    to_hash = "#{personal_key}--#{time.to_s}"
    token = Digest::SHA2.hexdigest(to_hash)[0..7]
  end
end
