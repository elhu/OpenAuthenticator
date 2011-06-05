class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :authenticate
  
  protected
  def authenticate
    
  end

end
