# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

include Rake::DSL
require File.expand_path('../config/application', __FILE__)
require 'rake'

Openauthenticator::Application.load_tasks

require 'reek/rake/task'
Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

desc "Runs RCov on the project (code coverage metrics)"
task :rcov => :environment do
  system("rcov --rails --exclude \"/usr|spec/*\" spec/spec_helper.rb")
end

desc "Runs Flay on the project (duplicate checker)"
task :flay => :environment do
  system("flay app")
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
