class Authentication < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :provider, :scope => :user_id
  validates_presence_of :user_id, :provider, :uid
end
