class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.text :post
      t.integer :user_id

      t.timestamps
    end
  end
end
