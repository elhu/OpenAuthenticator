# == Schema Information
#
# Table name: account_tokens
#
#  id            :integer         not null, primary key
#  account_token :string(255)
#  state         :string(255)
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class AccountToken < ActiveRecord::Base
  # model associations
  belongs_to :user

  # prevent foreign key change by mass assignment
  attr_accessible :account_token

  before_create :generate_account_token

  private
  def generate_account_token
    self.account_token = Digest::SHA2.hexdigest("#{Time.new.utc}--#{SecureRandom.base64(128)}")
    self.state = :active
  end
end
