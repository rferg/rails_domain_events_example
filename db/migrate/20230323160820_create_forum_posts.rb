# frozen_string_literal: true

class CreateForumPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :forum_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :title, null: false
      t.text :body, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
