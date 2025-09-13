module RailsSnowflake
  class Railtie < ::Rails::Railtie
    initializer "rails_snowflake.register_field_type" do
      ActiveSupport.on_load(:active_record) do
        Rails.logger.debug "RailsSnowflake: Registering snowflake field type"

        ActiveRecord::ConnectionAdapters::TableDefinition.prepend(RailsSnowflake::ConnectionAdapters::ColumnMethods)

        ActiveRecord::Type.register(:snowflake, ActiveRecord::Type::BigInteger, override: false)

        if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:snowflake] = { name: "bigint" }
          Rails.logger.debug "RailsSnowflake: Added snowflake to PostgreSQL native types"
        end

        Rails.logger.debug "RailsSnowflake: Snowflake field type registration complete"
      end
    end

    # Hook into database tasks to ensure sequences exist
    rake_tasks do
      load "rails_snowflake/database_tasks.rb"
    end
  end
end
