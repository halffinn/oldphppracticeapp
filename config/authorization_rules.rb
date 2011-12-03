authorization do

  role :superadmin do
    includes [:admin]
  end

  role :admin do
    includes [:default]
    has_permission_on [:users, :places, :place_types, :addresses, :availabilities, :comments], :to => [:manage]
    has_permission_on :users, :to => [:change_role]
    has_permission_on :places, :to => [:user_places, :publish, :user_places]
    has_permission_on :transactions, :to => [:cancel, :pay]
  end

  role :agent do
    includes [:default]
    has_permission_on :places, :to => [:create]
    has_permission_on :places, :to => [:manage, :publish, :user_places] do
      if_attribute :user => is { user }
    end
    has_permission_on [:availabilities, :comments], :to => [:manage] do
      if_permitted_to :manage, :place
    end
    has_permission_on :transactions, :to => :cancel do
      if_permitted_to :manage, :place
    end
  end

  role :user do
    includes [:default]
  end

  role :default do
    includes [:guest]
    has_permission_on [:users], :to => [:read, :update, :info, :delete] do
      if_attribute :id => is { user.id }
    end
    has_permission_on :registrations, :to => :destroy
    has_permission_on :addresses, :to => [:read, :manage] do
      if_attribute :user => is { user }
    end
    has_permission_on :comments, :to => :create do
      if_attribute :replying_to => is { nil }
    end
    has_permission_on :comments, :to => :read do
      if_attribute :user => is { user }
    end
    has_permission_on :notifications, :to => [:index, :unread, :mark_as_read]
    has_permission_on :authentications, :to => [:create, :list, :delete, :get_facebook_oauth_info]
    has_permission_on :messages, :to => [:index, :messages, :create, :destroy, :mark_as_read, :mark_as_unread, :unread_count]
    has_permission_on :places, :to => [:place_request, :check_availability] do
      if_permitted_to :read, :place
    end
    has_permission_on :transactions, :to => :cancel do
      if_attribute :user => is { user }
    end
  end
  
  role :guest do
    has_permission_on :users,       :to => [:info, :user_places]
    has_permission_on :place_types, :to => :read
    has_permission_on :places,      :to => :search
    has_permission_on :places,      :to => :read do
      if_attribute :published => is { true }
    end
    has_permission_on :availabilities, :to => :read do
      if_permitted_to :read, :place
    end
    has_permission_on :places, :to => :check_availability do
      if_permitted_to :read, :place
    end
    has_permission_on :passwords, :to => [:update, :create]
    has_permission_on :sessions, :to => [:create, :oauth_create]
    has_permission_on :confirmations, :to => [:show, :create]
    has_permission_on :registrations, :to => [:create, :check_email]
    has_permission_on :comments, :to => :read do
      if_attribute :comments_count => gt { 0 }
    end
    has_permission_on :geo, :to => [:get_countries, :get_states, :get_cities, :get_city, :city_search, :price_range]
  end

end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show, :list]
  privilege :create
  privilege :update
  privilege :delete, :includes => :destroy
end