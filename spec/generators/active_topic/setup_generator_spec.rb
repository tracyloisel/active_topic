# frozen_string_literal: true

require 'generators/active_topic/setup_generator'
require 'generator_spec'

RSpec.describe ActiveTopic::Generators::SetupGenerator, type: :generator do
  destination File.expand_path('../../../tmp', __dir__)

  before(:all) { prepare_destination }

  it 'creates the configuration file config/initializers/active_topic.rb' do
    run_generator

    assert_file('config/initializers/active_topic.rb', File.read('lib/generators/active_topic/templates/setup.rb'))
  end
end
