class ChangeColumnSessionIdToStringInUrlTrack < ActiveRecord::Migration
  def up
    remove_index :url_tracks, :session_id
    remove_column :url_tracks, :session_id
    add_column :url_tracks, :session_id, :string
    add_index :url_tracks, :session_id
  end

  def down
    remove_index :url_tracks, :session_id
    remove_column :url_tracks, :session_id
    add_column :url_tracks, :session_id, :integer
    add_index :url_tracks, :session_id
  end
end
