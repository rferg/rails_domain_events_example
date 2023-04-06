# frozen_string_literal: true

class CreateNotificationContents < ActiveRecord::Migration[7.0]
  def change
    create_table :notification_contents do |t|
      t.text :title, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
