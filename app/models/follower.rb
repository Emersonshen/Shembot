class Follower < ActiveRecord::Base

  def self.search(page)
    paginate :per_page => 15, :page => page
  end
end
