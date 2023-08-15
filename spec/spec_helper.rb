require 'simplecov'
require 'coveralls'

require 'sidekiq'
require 'rspec-sidekiq'

require 'active_job'
require 'action_mailer'

require_relative 'support/init'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [Coveralls::SimpleCov::Formatter, SimpleCov::Formatter::HTMLFormatter]
)

RSpec.configure do |config|
  #SimpleCov.start

  config.disable_monkey_patching!

  config.include RSpec::Sidekiq::Spec::Support::Factories
end

ActiveJob::Base.queue_adapter = :sidekiq

if Gem::Dependency.new('sidekiq', '>= 5.0.0').matching_specs.any?
  require 'active_record'
  ActiveSupport.run_load_hooks(:active_record, ActiveRecord::Base)
  #Sidekiq::Extensions.enable_delay!
  Sidekiq.strict_args!(false)
end
