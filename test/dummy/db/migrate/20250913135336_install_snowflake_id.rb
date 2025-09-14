# frozen_string_literal: true

class InstallSnowflakeId < ActiveRecord::Migration[8.0]
  def up
    # Create the timestamp_id PostgreSQL function
    Rails::Snowflake::Id.define_timestamp_id
  end

  def down
    # Remove the timestamp_id function
    execute "DROP FUNCTION IF EXISTS timestamp_id(text)"
  end
end
