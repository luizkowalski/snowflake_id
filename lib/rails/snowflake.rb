# frozen_string_literal: true

# Manually require all Rails::Snowflake modules
require_relative "snowflake/version"
require_relative "snowflake/id"
require_relative "snowflake/column_methods"
require_relative "snowflake/railtie"
require_relative "snowflake/generators/install/install_generator"


module Rails
  module Snowflake
    class Error < StandardError; end
  end
end
