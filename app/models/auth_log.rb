
# == Schema Information
#
# Table name: auth_logs
#
#  id               :integer         not null, primary key
#  account_token_id :integer
#  outcome          :boolean
#  created_at       :datetime
#  updated_at       :datetime
#

class AuthLog < ActiveRecord::Base
  # default scope for ordering
  default_scope :order => "auth_logs.created_at DESC"

  # model association
  belongs_to :account_token
end
