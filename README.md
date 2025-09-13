# RailsSnowflake

A Rails plugin that provides Snowflake-like IDs for your ActiveRecord models with minimal configuration.

Snowflake IDs are 64-bit integers that contain:
- **48 bits** for millisecond-level timestamp
- **16 bits** for sequence data (includes hashed table name + secret salt + sequence number)

This ensures globally unique, time-sortable IDs that don't reveal the total count of records in your database.

## Features

- 🚀 **Completely automatic** - Just use `t.snowflake` and it works!
- 🛠️ **Automatic database setup** - Hooks into `db:migrate` and `db:prepare`
- 🎯 **Custom generators** - Generate models with Snowflake IDs by default
- 📊 **Status monitoring** - Built-in rake tasks for management
- ✨ **Custom `t.snowflake` type** - Clean, Rails-like migrations

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rails_snowflake"
```

And then execute:
```bash
$ bundle
$ rails generate rails_snowflake:install
```

## Quick Start

**That's it!** Just use `t.snowflake` in your migrations and everything works automatically.

### For additional snowflake columns (non-primary key):
```ruby
class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.snowflake :external_id  # Additional snowflake column
      t.timestamps
    end
  end
end
```

### For snowflake primary keys:
```ruby
# Option 1: Using the dedicated method (recommended)
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.snowflake :id, primary_key: true  # Snowflake primary key
      t.string :name
      t.timestamps
    end
  end
end
```

### Generator Support

You can now use snowflake fields in Rails generators:

```bash
# Generate a model with a snowflake field
rails generate model Post title:string external_id:snowflake

# This will create a migration like:
# create_table :posts do |t|
#   t.string :title
#   t.snowflake :external_id
#   t.timestamps
# end
```

**Note**: When using `t.snowflake :id` directly, Rails will complain about redefining the primary key. Always use `create_table :table_name, id: false` when you want a snowflake primary key.

## Usage

### Generating Models

**Simple 2-step process:**

```bash
# 1. Generate model with standard Rails generator
$ rails generate model User name:string email:string

# 2. Edit the migration file
# Change the create_table block from:
create_table :users do |t|
  # ...
end

# To:
create_table :users, id: false do |t|
  t.snowflake :id, primary_key: true
  # ... rest of columns
end

# 3. Run migration
$ rails db:migrate
```

**Example migration:**
```ruby
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.snowflake :id, primary_key: true
      t.string :name
      t.string :email
      t.timestamps
    end
  end
end
```

**That's it!** The gem handles everything else automatically:
- ✅ Database function creation
- ✅ Sequence management

### Manual Migration Setup

The gem provides a custom `t.snowflake` type for clean migrations:

```ruby
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.snowflake :id, primary_key: true
      t.string :name
      t.string :email
      t.timestamps
    end
  end
end
```

### Working with Snowflake IDs

```ruby
user = User.create!(name: "Alice")
user.id  # => 1766655742123000001

# Convert ID back to timestamp
RailsSnowflake::Generator.to_time(user.id)
# => 2024-12-25 10:15:42 UTC

# Generate ID for specific timestamp
RailsSnowflake::Generator.id_at(1.hour.ago)
# => 1766651542000012345
```

## Management Commands

### Setup and Status

```bash
# Install and setup (run after adding gem)
$ rails generate rails_snowflake:install

# Setup database function and sequences
$ rails rails_snowflake:setup

# Check current status
$ rails rails_snowflake:status
```

### Database Integration

The gem automatically hooks into these Rails tasks:
- `db:migrate` - Ensures sequences exist after migrations
- `db:prepare` - Sets up function and sequences
- `db:setup` - Complete database initialization
- `db:reset` - Rebuilds database with Snowflake support

## Migration from Standard IDs

If you have existing models with standard Rails IDs, you'll need to:

1. Create a migration to change the primary key
2. Handle data migration carefully
3. Update any foreign key references

⚠️ **Warning**: This is a complex operation that may require downtime and careful planning.

## Advanced Usage

### Manual Control (Optional)

For advanced users who want explicit control:

```ruby
class User < ApplicationRecord
  acts_as_snowflake_id  # Optional - only if you want explicit control
end
```

But this is **not needed** - the gem automatically detects `t.snowflake` columns and sets up callbacks!

## Requirements

- **Database**: PostgreSQL (uses PostgreSQL-specific functions)
- **Rails**: 8.0+ (may work with earlier versions)
- **Ruby**: 3.0+

## How it Works

1. **Function Creation**: Creates a PostgreSQL `timestamp_id()` function
2. **Sequence Management**: Auto-creates sequences for each table (`table_name_id_seq`)
3. **ID Generation**: Uses timestamp + hashed sequence for uniqueness
4. **Rails Integration**: Hooks into model lifecycle and database tasks

The generated IDs are:
- **Sortable by creation time** (timestamp-based)
- **Globally unique** across tables
- **Non-sequential** (doesn't reveal record count)
- **64-bit integers** (compatible with most systems)

## Troubleshooting

### Database Connection Issues
```bash
$ rails rails_snowflake:status
# Check if function and sequences are properly set up
```

### Manual Function Setup
```sql
-- If auto-setup fails, you can manually run:
SELECT timestamp_id('users'::text);
```

### Sequence Issues
```bash
$ rails rails_snowflake:ensure_sequences
# Manually ensure all sequences exist
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Add tests for your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin feature/my-new-feature`)
6. Create a Pull Request

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
