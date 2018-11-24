class CreateWhyTags < ActiveRecord::Migration[5.2]
  def change
    create_table :why_tags do |t|
      t.string     :subject
      t.string     :subcategory
      t.string     :title
      t.string     :link
      t.text       :description

      t.timestamps
    end
  end
end
