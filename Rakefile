# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

#include Rake::DSL
require File.expand_path('../config/application', __FILE__)
require 'rake'

Openauthenticator::Application.load_tasks

desc "Runs simplecov on the project"
task :cov => :environment do
  system("/usr/bin/ruby1.9.1 -S bundle exec rspec ./spec/controllers/personal_key_controller_spec.rb ./spec/controllers/users_controller_spec.rb ./spec/controllers/auth_controller_spec.rb ./spec/controllers/account_token_controller_spec.rb ./spec/models/account_token_spec.rb ./spec/models/user_spec.rb ./spec/models/personal_key_spec.rb ./spec/models/pseudo_cookie_spec.rb ./spec/routing/users_routing_spec.rb")
end

desc "Runs Reek on the project (code smell checker)"
task :reek => :environment do
  system("reek app")
end

desc "Runs Flog on the project (code complexity metrics)"
task :flog => :environment do
  system("flog app")
end

desc "Runs Rails_best_practice on the project"
task :best_practice => :environment do
  system("rails_best_practices .")
end

