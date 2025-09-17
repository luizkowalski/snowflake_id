# frozen_string_literal: true

# Ensures that any tables using a snowflake primary key (:id with timestamp_id default)
# have their backing <table>_id_seq sequences present. This is necessary for tables
# created with `id: false` and a subsequent `t.snowflake :id, primary_key: true` where
# Rails does not auto-create the normal sequence.
def ensure_snowflake_sequences
  begin
    # Avoid establishing a new connection too early; skip if not connected yet.
    return unless ActiveRecord::Base.connection_pool.connected?

    adapter = ActiveRecord::Base.connection.adapter_name
    unless adapter == "PostgreSQL"
      Rails.logger.debug("Rails::Snowflake: Skipping sequence check (adapter=#{adapter})") if defined?(Rails)
      return
    end

    Rails.logger.debug "Rails::Snowflake: Ensuring sequences for timestamp_id columns" if defined?(Rails)

    Rails::Snowflake::Id.ensure_id_sequences_exist
  rescue ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished => e
    Rails.logger.debug "Rails::Snowflake: Skipping sequence ensure (#{e.class}: #{e.message})" if defined?(Rails)
  rescue StandardError => e
    Rails.logger.warn "Rails::Snowflake: Unexpected error while ensuring sequences: #{e.class}: #{e.message}" if defined?(Rails)
  end
end

def enhance_snowflake_db_task(name)
  return unless Rake::Task.task_defined?(name)

  Rake::Task[name].enhance do
    ensure_snowflake_sequences
  end
end

# Enhance a broad set of lifecycle tasks; migrate first so tests pick it up.
%w[
  db:migrate
  db:setup
  db:prepare
  db:reset
  db:schema:load
  db:structure:load
  db:seed
  db:test:prepare
].each { |t| enhance_snowflake_db_task(t) }
