class CreatePhotoData < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_data do |t|
      t.string :name
      t.string :username
      t.integer :postphoto_id
      t.boolean :verified
      t.datetime :verified_time
      t.integer :verified_user_id
      t.string :is_bot
      t.boolean :rejected
      t.string :rejected_comment
      t.datetime :rejected_time
      t.integer :rejected_user_id
      t.string :rejected_cancel_comment
      t.datetime :rejected_cancel_time
      t.integer :rejected_cancel_user_id
      t.integer :points
      t.string :url
      t.string :photo_url
      t.string :text
      t.integer :photo_tag_id


      t.timestamps
    end
  end
end
