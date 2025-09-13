require_relative "lib/snowflake_id/version"

Gem::Specification.new do |spec|
  spec.name        = "snowflake_id"
  spec.version     = SnowflakeId::VERSION
  spec.authors     = [ "Luiz Eduardo Kowalski" ]
  spec.email       = [ "luizeduardokowalski@gmail.com" ]
  spec.homepage    = "https://github.com/luizkowalski/snowflake_id/"
  spec.summary     = "Generate Snowflake IDs in Rails models."
  spec.description = "A Rails plugin that provides a simple way to generate unique Snowflake IDs for your ActiveRecord models."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/luizkowalski/snowflake_id"
  spec.metadata["changelog_uri"] = "https://github.com/luizkowalski/snowflake_id/CHAGNES.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.2"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.required_ruby_version = ">= 3.2"
end
