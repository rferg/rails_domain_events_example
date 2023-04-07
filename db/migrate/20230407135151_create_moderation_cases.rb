class CreateModerationCases < ActiveRecord::Migration[7.0]
  def change
    create_table :moderation_cases do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.string :category, null: false

      t.timestamps
    end
  end
end
