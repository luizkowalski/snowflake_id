require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/generators")
loader.ignore("#{__dir__}/snowflake_id/database_tasks.rb")
loader.setup

require "snowflake_id/railtie"

module SnowflakeId; end
