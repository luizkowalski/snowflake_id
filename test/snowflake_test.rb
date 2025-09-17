# frozen_string_literal: true

require "test_helper"

class SnowflakeTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Rails::Snowflake::VERSION
  end

  test "installs timestamp_id function on database setup" do
    result = ActiveRecord::Base.connection.exec_query("SELECT timestamp_id('orders'::text)")

    assert_equal 1, result.rows.length
    assert_kind_of Integer, result.rows.first.first
    assert_operator result.rows.first.first, :>, 0
  end

  test "creates user with snowflake primary key" do
    user = User.create!(name: "Test User", email: "test@example.com")

    assert_predicate user, :persisted?
    assert_kind_of Integer, user.id
    assert_operator user.id, :>, 0

    # Snowflake IDs should be much larger than typical auto-increment IDs
    assert_operator user.id, :>, 2**32, "Snowflake ID should be larger than 32-bit integer" # 16-digit minimum
  end

  test "creates post with snowflake external_id" do
    post = Post.create!(title: "Test Post", content: "Content")

    assert_predicate post, :persisted?
    assert_kind_of Integer, post.id # Regular Rails auto-increment ID
    assert_kind_of Integer, post.external_id # Snowflake ID
    assert_operator post.external_id, :>, 2**32, "Snowflake ID should be larger than 32-bit integer"
  end

  test "creates order with multiple snowflake columns" do
    order = Order.create!(amount: 99.99)

    assert_predicate order, :persisted?
    assert_kind_of Integer, order.id # Snowflake primary key
    assert_kind_of Integer, order.tracking_id # Snowflake column
    assert_kind_of Integer, order.confirmation_id # Snowflake column

    # All snowflake IDs should be large
    assert_operator order.id, :>, 2**32, "Snowflake ID should be larger than 32-bit integer"
    assert_operator order.tracking_id, :>, 2**32, "Snowflake ID should be larger than 32-bit integer"
    assert_operator order.confirmation_id, :>, 2**32, "Snowflake ID should be larger than 32-bit integer"

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

    assert_operator user1.id, :<, user2.id
    assert_operator user2.id, :<, user3.id
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
