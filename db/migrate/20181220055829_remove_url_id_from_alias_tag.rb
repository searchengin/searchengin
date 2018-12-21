class RemoveUrlIdFromAliasTag < ActiveRecord::Migration[5.2]
  def change
    remove_column :alias_tags, :url_id
  end
end
