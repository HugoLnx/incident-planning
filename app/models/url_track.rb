class UrlTrack < ActiveRecord::Base
  default_scope{order(datetime: :desc)}
end
