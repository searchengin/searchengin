class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string  :name
      t.integer :count, default: 0
      t.integer :order_number, default: 9999
      t.text    :html

      t.timestamps
    end
  end
end
