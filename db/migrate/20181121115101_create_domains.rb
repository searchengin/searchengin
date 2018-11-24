class CreateDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :domains do |t|
      t.text    :domain
      t.integer :points, default: 0
      t.integer :average, default: 0
      t.integer :urls_count, default: 0

      t.timestamps
    end
  end
end
