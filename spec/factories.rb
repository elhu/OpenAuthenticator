Factory.define :user do |user|
  user.first_name            "Foo"
  user.last_name             "Bar"
  user.login                 "foobar"
  user.email                 "foo@bar.com"
  user.birthdate             Date.strptime("12/11/1986", "%d/%m/%Y")
end

