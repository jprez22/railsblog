class AddPostIdToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :post_id, :integer
  end
end
