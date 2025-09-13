module RailsSnowflake
  class Railtie < ::Rails::Railtie
    # Hook into database tasks to ensure sequences exist
    rake_tasks do
      load "rails_snowflake/database_tasks.rb"
    end
  end
end
