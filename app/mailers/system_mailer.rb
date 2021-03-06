class SystemMailer < BaseMailer
  default :to => SiteConfig.mail_bcc

  # ==Description
  # Email sent when the user sends feedback
  def user_feedback(user, type, message)
    @user = user
    @type = type
    @message = message

    mail(:subject => "User Feedback (#{type})")
  end

  # ==Description
  # Email sent when the user receives a message
  def new_message_admin(from_user, to_user, message)
    @from_user = from_user
    @to_user   = to_user
    @message   = message

    mail(:subject => "#{@to_user.full_name} has a new message!")
  end
end