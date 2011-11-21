class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :xml, :json

  # == Description
  # Returns all the conversations of the current user
  # ==Resource URL
  # /conversations.format
  # ==Example
  # GET https://backend-heypal.heroku.com/conversations.json
  # === Parameters
  # [:access_token]
  # == Errors
  # [115] no result
  def index
    check_token
    
    @conversations = []
    Message.conversations.each{|with_user|
      last_message = ActiveSupport::JSON::decode(Message.last_message_with(with_user)[0])
      if Message.is_read?(last_message['to'].to_i)
        @conversations << last_message.merge!({:isread => true})
      else
        @conversations << last_message.merge!({:isread => false})
      end
    }
    if @conversations
      return_message(200, :ok, {:conversations => @conversations})
    else
      return_message(200, :ok, {:err => {:conversations => [115]}})
    end
  end

  # == Description
  # Returns all the messages with another user and marks conversation as read
  # ==Resource URL
  # /messages/user.format
  # ==Example
  # GET https://backend-heypal.heroku.com/messages/2.json
  # === Parameters
  # [:access_token]
  # [:user] The other user in the conversation
  # == Errors
  # [106] User not found
  # [115] no results
  def messages
    check_token
    
    foo = User.find(params['id'])
    @messages = []
    Message.messages_with(params['id']).each{|message|
      @messages << ActiveSupport::JSON::decode(message)
    }
    if @messages
      return_message(200, :ok, {:messages => @messages})
    else
      return_message(200, :ok, {:err => {:messages => [115]}})
    end
  end

  # == Description
  # Sends a messages to another user
  # ==Resource URL
  # /messages/user.format
  # ==Example
  # POST https://backend-heypal.heroku.com/messages/2.json message="Message content"
  # === Parameters
  # [:access_token]
  # [:user]    The other user in the conversation
  # [:message] The content of the message
  # == Errors
  # [106] User not found
  def create
    check_token
    
    if Message.to(params['id'], params['message'])
      return_message(200, :ok)
    else
      return_message(200, :ok, {:err => {:messages => [106]}})
    end
  end
  
  # == Description
  # Deletes a conversation with another user
  # ==Resource URL
  # /messages/user.format
  # ==Example
  # DELETE https://backend-heypal.heroku.com/messages/2.json
  # === Parameters
  # [:access_token]
  # [:user]    The other user in the conversation
  # == Errors
  # [106] User not found
  def destroy
    check_token
    if Message.delete_conversation_with(params['id'])
      return_message(200, :ok)
    else
      return_message(200, :ok, {:err => {:messages => [106]}})
    end
  end

  # == Description
  # Marks a conversation with another user as read
  # ==Resource URL
  # /conversations/user/mark_as_read.format
  # ==Example
  # PUT https://backend-heypal.heroku.com/conversations/2/mark_as_read.json
  # === Parameters
  # [:access_token]
  # [:user]    The other user in the conversation
  # == Errors
  # [106] User not found or already read
  def mark_as_read
    check_token
    if Message.mark_as_read(params['id'])
      return_message(200, :ok)
    else
      return_message(200, :ok, {:err => {:messages => [106]}})
    end
  end

  # == Description
  # Marks a conversation with another user as unread
  # ==Resource URL
  # /conversations/user/mark_as_unread.format
  # ==Example
  # PUT https://backend-heypal.heroku.com/conversations/2/mark_as_unread.json
  # === Parameters
  # [:access_token]
  # [:user]    The other user in the conversation
  # == Errors
  # [106] User not found or already read
  def mark_as_read
    check_token
    if Message.mark_as_unread(params['id'])
      return_message(200, :ok)
    else
      return_message(200, :ok, {:err => {:messages => [106]}})
    end
  end
  
  # == Description
  # Returns the number of unread conversations for the current user
  # ==Resource URL
  # /conversations/unread_count.format
  # ==Example
  # GET https://backend-heypal.heroku.com/conversations/unread_count.json
  # === Parameters
  # [:access_token]
  def unread_count
    check_token
    return_message(200, :ok, :count => Message.unread_count)
  end
end