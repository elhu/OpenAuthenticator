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

class PseudoCookie < ActiveRecord::Base
  # model associations
  belongs_to :user

  # forbid any mass assignment
  attr_accessible :none
  
  # validation rules for PseudoCookie model
  validates :user_id, :presence => true, :uniqueness => true
  validates :expire, :presence => true
  validates :cookie, :presence => true, :uniqueness => true
  
  def self.generate_cookie(user_id)
    if not User.find_by_id(user_id).pseudo_cookie.nil?
      User.find_by_id(user_id).pseudo_cookie.destroy
    end
    cookie = PseudoCookie.new
    cookie.user_id = user_id
    cookie.expire = Time.new + (10 * 60)
    cookie.cookie = Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}") + user_id.to_s
    cookie.save!
    cookie
  end
  
  # TODO:
  # finish pseudo_cookie handling
  # add pseudo_cookie verification for restricted actions
end


