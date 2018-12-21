class CreateVideoData < ActiveRecord::Migration[5.2]
  def change
    create_table :video_data do |t|
      t.text    :video_url
      t.string  :category
      t.text    :description
      t.text    :html_code
      t.integer :video_tag_id

      t.timestamps
    end
  end
end
