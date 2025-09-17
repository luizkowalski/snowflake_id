# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "rails/snowflake"

class GeneratorInstallTest < Rails::Generators::TestCase
  tests Rails::Snowflake::Generators::InstallGenerator
  destination File.expand_path("tmp/generator_test", __dir__)

  setup do
    prepare_destination
  end

  def test_generator_creates_migration
    run_generator
    files = Dir[File.join(destination_root, "db/migrate/*install_snowflake_id.rb")]

    assert_predicate files, :any?, "Expected install_snowflake_id migration to be created"
    content = File.read(files.first)

    assert_match "Rails::Snowflake::Id.define_timestamp_id", content
  end
end
