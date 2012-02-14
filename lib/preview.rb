class Preview < MailView
  def confirmation_instructions
    user = User.first
    RegistrationMailer.confirmation_instructions(user)
  end

  def reset_password
    user = User.first
    RegistrationMailer.reset_password_instructions(user)
  end
  
  #def welcome
  #  user = User.first
  #  Devise::Mailer.welcome_instructions(user)
  #end
end