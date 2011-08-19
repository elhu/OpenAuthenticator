Factory.define :user do |user|
  user.first_name            "Foo"
  user.last_name             "Bar"
  user.login                 "foobar"
  user.email                 "foo@bar.com"
  user.birthdate             Date.strptime("12/11/1986", "%d/%m/%Y")
end

Factory.define :account_token do |account_token|
  account_token.label        "test"
  account_token.user_id      1
end

Factory.define :auth_log do |auth_log|
	auth_log.account_token_id		1
	auth_log.outcome					false
end

Factory.define :sync_token do |sync_token|
	sync_token.user_id					1
end