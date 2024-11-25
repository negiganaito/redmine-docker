class AddCreatedAtToCmsContentVersion < ActiveRecord::Migration[4.2]
  def change
    add_column :cms_content_versions, :created_at, :datetime
    add_column :cms_content_versions, :updated_at, :datetime
  end
end
