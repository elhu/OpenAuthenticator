# == Schema Information
#
# Table name: auth_logs
#
#  id            :integer         not null, primary key
#  account_token :integer
#  outcome       :boolean
#  created_at    :datetime
#  updated_at    :datetime
#

class AuthLog < ActiveRecord::Base
  # model association
  belongs_to :account_token
end
