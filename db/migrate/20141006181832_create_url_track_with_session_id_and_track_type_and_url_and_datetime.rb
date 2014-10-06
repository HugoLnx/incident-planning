class CreateUrlTrackWithSessionIdAndTrackTypeAndUrlAndDatetime < ActiveRecord::Migration
  def change
    create_table :url_tracks do |t|
      t.integer :session_id
      t.string :track_type
      t.string :url
      t.datetime :datetime
    end
    add_index :url_tracks, :session_id
    add_index :url_tracks, :track_type
  end
end
