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
