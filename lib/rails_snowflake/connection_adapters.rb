# frozen_string_literal: true

module RailsSnowflake
  module ConnectionAdapters
    module ColumnMethods
      def snowflake(name, **options)
        if name == :id && options[:primary_key] != true
          raise ArgumentError, "Cannot use t.snowflake :id directly. Use `create_table` with `id: false` and then t.snowflake :id, primary_key: true"
        end

        table_name = @name
        unless table_name
          raise ArgumentError, "Could not determine table name for snowflake column. " \
                              "Make sure you're using this within a create_table block."
        end

        options[:default] = -> { "timestamp_id('#{table_name}'::text)" }
        column(name, :bigint, **options)
      end
    end
  end
end
