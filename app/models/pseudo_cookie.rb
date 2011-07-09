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
  
  # validation rules for PseudoCookie model
  validates :user_id, :presence => true, :uniqueness => true
  validates :expire, :presence => true
  validates :cookie, :presence => true, :uniqueness => true
  
  def self.generate_cookie(user_id)
    prev_cookie = User.find_by_id(user_id).pseudo_cookie
    prev_cookie.destroy unless prev_cookie.nil?
    content = { :user_id => user_id,
      :expire => Time.new + (10 * 60),
      :cookie => OaUtils.generate_random_key + user_id.to_s
    }
    cookie = PseudoCookie.create(content)
    cookie if cookie.save!
  end
end


