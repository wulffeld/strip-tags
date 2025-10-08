class User < ActiveRecord::Base
  strip_tags only: [:name]
end
