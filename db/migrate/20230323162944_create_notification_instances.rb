# frozen_string_literal: true

class CreateNotificationInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :notification_instances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notification_content, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
