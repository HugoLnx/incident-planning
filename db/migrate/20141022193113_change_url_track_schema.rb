class ChangeUrlTrackSchema < ActiveRecord::Migration
  def up
    remove_column :url_tracks, :track_type
    add_column :url_tracks, :get_referer, :boolean, default: false
    add_column :url_tracks, :general_referer, :boolean, default: false
    add_column :url_tracks, :from_config_referer, :boolean, default: false
    add_column :url_tracks, :is_backable, :boolean, default: false
  end

  def down
    remove_column :url_tracks, :get_referer
    remove_column :url_tracks, :general_referer
    remove_column :url_tracks, :from_config_referer
    remove_column :url_tracks, :is_backable
    add_column :url_tracks, :track_type, :string
  end
end
