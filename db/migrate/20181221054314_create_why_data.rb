class CreateWhyData < ActiveRecord::Migration[5.2]
  def change
    create_table :why_data do |t|
      t.string     :subject
      t.string     :subcategory
      t.string     :title
      t.string     :link
      t.text       :description
      t.integer    :why_tag_id

      t.timestamps
    end
  end
end
