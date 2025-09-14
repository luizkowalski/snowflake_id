# frozen_string_literal: true

module Rails
  module Snowflake
    module ColumnMethods
    def snowflake(name, **options)
      if name == :id && !options[:primary_key]
        raise Error, "Cannot use t.snowflake :id directly. Use `create_table` with `id: false` and then `t.snowflake :id, primary_key: true`"
      end

      table_name = @name
      raise Error, "Could not determine table name for Snowflake column. Make sure you're using it within a `create_table` block." unless table_name

      options[:default] = -> { "timestamp_id('#{table_name}'::text)" }

      ensure_sequence_for(table_name) if name == :id && options[:primary_key]

      column(name, :bigint, **options)
    end

    private

    def ensure_sequence_for(table_name)
      seq_name = "#{table_name}_id_seq"
      adapter = ActiveRecord::Base.connection
      return unless adapter.adapter_name == "PostgreSQL"

      adapter.execute(<<~SQL)
        DO $$
        BEGIN
          CREATE SEQUENCE #{adapter.quote_column_name(seq_name)};
        EXCEPTION WHEN duplicate_table THEN
          -- sequence already exists
        END
        $$ LANGUAGE plpgsql;
      SQL
    rescue StandardError => e
      Rails.logger.debug "Rails::Snowflake: Could not create sequence #{seq_name}: #{e.class}: #{e.message}" if defined?(Rails)
    end
    end
  end
end
