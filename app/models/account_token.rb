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
#  label         :string(255)
#

class AccountToken < ActiveRecord::Base
  # scope definitions
  scope :active, where(:state => :active)
  
  # model associations
  belongs_to :user

  # prevent foreign key change by mass assignment
  attr_accessible :label

  # creates the account token before save
  before_create :generate_account_token

  # validations
  validates :label, :presence => true

  def revoke
    self.state = :revoked
    self.save
  end

  private
  # generate the account token randomly
  def generate_account_token
    self.account_token = OaUtils.generate_random_key
    self.state = :active
  end
end

