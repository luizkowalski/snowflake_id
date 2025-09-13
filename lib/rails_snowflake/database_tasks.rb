# frozen_string_literal: true

# Hook into Rails database tasks to ensure snowflake sequences exist
def ensure_snowflake_sequences
  return unless defined?(ActiveRecord::Base)

  begin
    if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
      puts "RailsSnowflake: Ensure sequences exist for timestamp_id columns"
      RailsSnowflake::Id.ensure_id_sequences_exist
    end
  rescue ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished
    # Database doesn't exist yet or not connected, skip
  rescue => e
    Rails.logger.warn "RailsSnowflake: Could not ensure sequences: #{e.message}"
  end
end

# Enhance existing Rails database tasks by adding our hook to them
if Rake::Task.task_defined?("db:migrate")
  Rake::Task["db:migrate"].enhance do
    ensure_snowflake_sequences
  end
end

if Rake::Task.task_defined?("db:schema:load")
  Rake::Task["db:schema:load"].enhance do
    ensure_snowflake_sequences
  end
end

if Rake::Task.task_defined?("db:structure:load")
  Rake::Task["db:structure:load"].enhance do
    ensure_snowflake_sequences
  end
end

if Rake::Task.task_defined?("db:seed")
  Rake::Task["db:seed"].enhance do
    ensure_snowflake_sequences
  end
end
