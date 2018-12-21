class CreateWhereData < ActiveRecord::Migration[5.2]
  def change
    create_table :where_data do |t|
      t.string     :location
      t.text       :description
      t.integer    :where_tag_id

      t.timestamps
    end
  end
end
