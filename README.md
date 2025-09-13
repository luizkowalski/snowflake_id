# SnowflakeId

A Rails plugin that provides Snowflake-like IDs for your ActiveRecord models with minimal configuration.

Snowflake IDs are 64-bit integers that contain:
- **48 bits** for millisecond-level timestamp
- **16 bits** for sequence data (includes hashed table name + secret salt + sequence number)

This ensures globally unique, time-sortable IDs that don't reveal the total count of records in your database.

## Features

- **Transparent** - Just use `t.snowflake` and it works automatically
- **Automatic database setup** - Hooks into `db:migrate` and `db:prepare` tasks to ensure everything is set up.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "snowflake_id"
```

And then execute:
```bash
rails generate snowflake_id:install
```

## Quick Start

**That's it!** Just use `t.snowflake` in your migrations and everything works automatically.

### For Snowflake ID as primary key:
```ruby
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

**Note**: When using `t.snowflake :id` directly, Rails will complain about redefining the primary key. Always use `create_table :table_name, id: false` when you want a snowflake primary key.

### For additional snowflake columns (non-primary key):
```ruby
class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.snowflake :uid  # Additional snowflake column
      t.timestamps
    end
  end
end
```

### Generator Support

You can also use Snowflake helper in Rails generators:

```bash
# Generate a model with a snowflake field
rails generate model Post title:string uid:snowflake

# This will create a migration like:
# create_table :posts do |t|
#   t.string :title
#   t.snowflake :uid
#   t.timestamps
# end
```

### Working with Snowflake IDs

There's nothing else to be done at this point. `t.snowflake` columns will automatically get unique IDs on record creation, and they are just a `:bigint` column in the database.
At this point, you can use them like any other integer ID.

```ruby
user = User.create!(name: "Alice")
user.id  # => 115198501587747344

# Convert ID back to timestamp
SnowflakeId::Generator.to_time(user.id)
# => 2024-12-25 10:15:42 UTC

# Generate ID for specific timestamp
SnowflakeId::Generator.at(1.hour.ago)
# => 1766651542000012345
```

### Database Integration

The gem automatically hooks into these Rails tasks:
- `db:migrate`
- `db:schema:load`
- `db:structure:load`
- `db:seed`

## Migration from Standard IDs

If you have existing models with standard Rails IDs, you'll need to run a migration to convert them to Snowflake IDs.

```ruby
execute("ALTER TABLE table_name ALTER COLUMN id SET DEFAULT timestamp_id('table_name')")
```

⚠️ **Warning**: This is a complex operation that may require downtime and careful planning.

## Requirements

- **Database**: PostgreSQL (uses PostgreSQL-specific functions)
- **Rails**: 7.2+ (may work with earlier versions)
- **Ruby**: 3.2+

## How it Works

1. **Function Creation**: Creates a PostgreSQL `timestamp_id()` function
2. **Sequence Management**: Auto-creates sequences for each table (`table_name_id_seq`)
3. **ID Generation**: Uses timestamp + hashed sequence for uniqueness
4. **Rails Integration**: Hooks into model lifecycle and database tasks


## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Add tests for your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin feature/my-new-feature`)
6. Create a Pull Request

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Acknowledgements

The implementation of Snowflake-like ids was initially done by [Mastodon](https://github.com/mastodon/mastodon/blob/06803422da3794538cd9cd5c7ccd61a0694ef921/lib/mastodon/snowflake.rb)
