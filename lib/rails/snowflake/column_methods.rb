# frozen_string_literal: true

module Rails
  module Snowflake
    module ColumnMethods
    def snowflake(name, **options)
      if name == :id && !options[:primary_key]
        raise Error, "Cannot use t.snowflake :id directly. Use `create_table` with `id: false` and then `t.snowflake :id, primary_key: true`"
      end

      unless @name
        raise Error, "Could not determine table name for Snowflake column. Make sure you're using it within a `create_table` block."
      end

      options[:default] = -> { "timestamp_id('#{@name}'::text)" }

      column(name, :bigint, **options)
    end
    end
  end
end
