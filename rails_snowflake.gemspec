require_relative "lib/rails_snowflake/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_snowflake"
  spec.version     = RailsSnowflake::VERSION
  spec.authors     = [ "Luiz Eduardo Kowalski" ]
  spec.email       = [ "luizeduardokowalski@gmail.com" ]
  spec.homepage    = "https://github.com/luizkowalski/rails_snowflake"
  spec.summary     = "Generate Snowflake IDs in Rails models."
  spec.description = "A Rails plugin that provides a simple way to generate unique Snowflake IDs for your ActiveRecord models."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/luizkowalski/rails_snowflake"
  spec.metadata["changelog_uri"] = "https://github.com/luizkowalski/rails_snowflake/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.2.1"
end
