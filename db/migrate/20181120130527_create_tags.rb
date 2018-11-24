class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string     :kind
      t.string     :name
      t.string     :username
      t.string     :postphoto_id

      t.boolean    :verified, default: false
      t.time       :verified_time
      t.integer    :verified_user_id

      t.boolean    :is_bot, default: false
      t.boolean    :rejected, default: false
      t.text       :rejected_comment
      t.time       :rejected_time
      t.integer    :rejected_user_id

      t.text       :rejected_cancel_comment
      t.time       :rejected_cancel_time
      t.integer    :rejected_cancel_user_id
      t.integer    :points, default: 0

      t.references :user, foreign_key: true, index: true
      t.references :url, foreign_key: true, index: true

      t.timestamps
    end

    add_index :tags, :verified_user_id
    add_index :tags, :rejected_user_id
    add_index :tags, :rejected_cancel_user_id

    add_foreign_key :tags, :users, column: :verified_user_id
    add_foreign_key :tags, :users, column: :rejected_user_id
    add_foreign_key :tags, :users, column: :rejected_cancel_user_id

  end
end
