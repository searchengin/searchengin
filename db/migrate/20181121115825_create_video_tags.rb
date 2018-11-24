class CreateVideoTags < ActiveRecord::Migration[5.2]
  def change
    create_table :video_tags do |t|
      t.text    :video_url
      t.string  :category
      t.text    :description
      t.text    :html_code

      t.timestamps
    end
  end
end
