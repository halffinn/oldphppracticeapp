class NotificationsController < ApiController

  # == Description
  # Returns all the notifications of the current user
  # ==Resource URL
  # /notifications.format
  # ==Example
  # GET https://backend-heypal.heroku.com/notifications.json
  # === Parameters
  # [access_token]
  # == Errors
  # [115] no result
  def index
    @notifications = []
    Notification.all.each{|foo|
      @notifications << ActiveSupport::JSON::decode(foo)
      }
    if @notifications
      return_message(200, :ok, {:notifications => @notifications})
    else
      return_message(200, :ok, {:err => {:notifications => [115]}})
    end
  end

  # == Description
  # Returns all the unread notifications of the current user
  # ==Resource URL
  # /notifications/unread.format
  # ==Example
  # GET https://backend-heypal.heroku.com/notifications/unread.json
  # === Parameters
  # [access_token]
  # == Errors
  # [115] no results
  def unread
    @notifications = []
    Notification.unread.each{|foo|
      @notifications << ActiveSupport::JSON::decode(foo)
      }
    if @notifications
      return_message(200, :ok, {:notifications => @notifications})
    else
      return_message(200, :ok, {:err => {:notifications => [115]}})
    end
  end
  
  # == Description
  # Marks
  # ==Resource URL
  # /notifications/mark_as_read.format
  # ==Example
  # GET https://backend-heypal.heroku.com/notifications/mark_as_read.json
  # === Parameters
  # [access_token]
  def mark_as_read
    if Notification.mark_as_read
      return_message(200, :ok)
    else
      return_message(200, :fail)
    end
  end  
end