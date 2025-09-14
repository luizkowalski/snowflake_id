class CreateTestModels < ActiveRecord::Migration
  def change
    # Test model with snowflake primary key
    create_table :users, id: false do |t|
      t.snowflake :id, primary_key: true
      t.string :name
      t.string :email
      t.timestamps
    end

    # Test model with regular primary key and snowflake column
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.snowflake :external_id
      t.bigint :user_id
      t.timestamps
    end

    # Test model with multiple snowflake columns
    create_table :orders, id: false do |t|
      t.snowflake :id, primary_key: true
      t.snowflake :tracking_id
      t.snowflake :confirmation_id
      t.decimal :amount
      t.timestamps
    end
  end
end
