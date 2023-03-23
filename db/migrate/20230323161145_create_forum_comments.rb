# frozen_string_literal: true

class CreateForumComments < ActiveRecord::Migration[7.0]
  def change
    create_table :forum_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :forum_post, null: false, foreign_key: true
      t.text :body, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
