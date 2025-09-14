require_relative "lib/rails/snowflake/version"

Gem::Specification.new do |spec|
  spec.name        = "rails-snowflake"
  spec.version     = Rails::Snowflake::VERSION
  spec.authors     = [ "Luiz Eduardo Kowalski" ]
  spec.email       = [ "luizeduardokowalski@gmail.com" ]
  spec.homepage    = "https://github.com/luizkowalski/snowflake_id/"
  spec.summary     = "Database-backed Snowflake IDs for Rails models."
  spec.description = "A Rails plugin that provides a simple way to generate unique Snowflake IDs for your ActiveRecord models."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/luizkowalski/snowflake_id"
  spec.metadata["changelog_uri"] = "https://github.com/luizkowalski/snowflake_id/CHANGES.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # Support Rails 7.1, 7.2 and 8.0. Cap at < 8.1 until verified.
  spec.add_dependency "rails", ">= 7.1", "< 8.1"

  spec.required_ruby_version = ">= 3.2"
end
