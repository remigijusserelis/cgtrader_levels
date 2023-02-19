# frozen_string_literal: true

require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:',
  verbosity: 'quiet'
)

ActiveRecord::Base.connection.create_table :users do |table|
  table.string :username
  table.integer :reputation, default: 0
  table.decimal :coins, default: 0
  table.decimal :tax, default: 30
  table.references :level
end

ActiveRecord::Base.connection.create_table :levels do |table|
  table.string :title, null: false
  table.integer :experience, null: false
end

ActiveRecord::Base.connection.create_table :rewards do |table|
  table.string :reward_type, null: false
  table.decimal :amount, default: 0, null: false
end

ActiveRecord::Base.connection.create_join_table :levels, :rewards