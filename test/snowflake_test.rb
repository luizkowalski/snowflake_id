# frozen_string_literal: true

require "test_helper"

class SnowflakeTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Rails::Snowflake::VERSION
  end

  test "installs timestamp_id function on database setup" do
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
    sleep 0.001
    user2 = User.create!(name: "User 2", email: "user2@example.com")
    sleep 0.001
    user3 = User.create!(name: "User 3", email: "user3@example.com")

    assert user1.id < user2.id
    assert user2.id < user3.id
  end

  test "snowflake column method detects id without primary_key configuration" do
    assert_raises(Rails::Snowflake::Error, match: /Cannot use t.snowflake :id directly/) do
      ActiveRecord::Migration[7.1].new.instance_eval do
        create_table :bad_table do |t|
          t.snowflake :id
        end
      end
    end
  end

  test "snowflake column method detects id with primary_key set to false " do
    assert_raises(Rails::Snowflake::Error, match: /Cannot use t.snowflake :id directly/) do
      ActiveRecord::Migration[7.1].new.instance_eval do
        create_table :bad_table do |t|
          t.snowflake :id, primary_key: false
        end
      end
    end
  end
end
