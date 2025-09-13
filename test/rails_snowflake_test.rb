require "test_helper"

class RailsSnowflakeTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert RailsSnowflake::VERSION
  end

  test "installs timestamp_id function on database setup" do
    # The function should be available after our railtie loads
    result = ActiveRecord::Base.connection.exec_query("SELECT timestamp_id('orders'::text)")

    assert result.rows.length == 1
    assert result.rows.first.first.is_a?(Integer)
    assert result.rows.first.first > 0
  end

  test "creates user with snowflake primary key" do
    user = User.create!(name: "Test User", email: "test@example.com")

    assert user.persisted?
    assert user.id.is_a?(Integer)
    assert user.id > 0

    # Snowflake IDs should be much larger than typical auto-increment IDs
    assert user.id > 2**32, "Snowflake ID should be larger than 32-bit integer" # 16-digit minimum
  end

  test "creates post with snowflake external_id" do
    post = Post.create!(title: "Test Post", content: "Content")

    assert post.persisted?
    assert post.id.is_a?(Integer) # Regular Rails auto-increment ID
    assert post.external_id.is_a?(Integer) # Snowflake ID
    assert post.external_id > 2**32, "Snowflake ID should be larger than 32-bit integer"
  end

  test "creates order with multiple snowflake columns" do
    order = Order.create!(amount: 99.99)

    assert order.persisted?
    assert order.id.is_a?(Integer) # Snowflake primary key
    assert order.tracking_id.is_a?(Integer) # Snowflake column
    assert order.confirmation_id.is_a?(Integer) # Snowflake column

    # All snowflake IDs should be large
    assert order.id > 2**32, "Snowflake ID should be larger than 32-bit integer"
    assert order.tracking_id > 2**32, "Snowflake ID should be larger than 32-bit integer"
    assert order.confirmation_id > 2**32, "Snowflake ID should be larger than 32-bit integer"

    # All IDs should be different
    assert_not_equal order.id, order.tracking_id
    assert_not_equal order.id, order.confirmation_id
    assert_not_equal order.tracking_id, order.confirmation_id
  end

  test "snowflake IDs are time-sortable" do
    # Create records with small delays to test time ordering
    user1 = User.create!(name: "User 1", email: "user1@example.com")
    sleep 0.001 # 1ms delay
    user2 = User.create!(name: "User 2", email: "user2@example.com")
    sleep 0.001
    user3 = User.create!(name: "User 3", email: "user3@example.com")

    # IDs should be in ascending order due to timestamp component
    assert user1.id < user2.id
    assert user2.id < user3.id
  end

  test "database tasks hook ensures sequences exist" do
    # This is tested implicitly by the fact that our migrations work
    # The database_tasks.rb file hooks into db:migrate to run ensure_id_sequences_exist
    # If it didn't work, our snowflake columns wouldn't get proper defaults

    # Test that we can create records (which means sequences exist)
    user = User.create!(name: "Sequence Test", email: "sequence@test.com")
    assert user.persisted?
    assert user.id > 0
  end

  test "snowflake column method detects id conflict" do
    # Test that trying to use t.snowflake :id raises helpful error
    assert_raises(ArgumentError) do
      ActiveRecord::Migration.new.instance_eval do
        create_table :bad_table do |t|
          t.snowflake :id
        end
      end
    end
  end
end
