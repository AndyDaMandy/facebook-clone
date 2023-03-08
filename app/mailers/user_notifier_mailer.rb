class UserNotifierMailer < Devise::Mailer

  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  require 'sendgrid-ruby'
    include SendGrid

    from = Email.new(email: 'andy.dev.mailer@gmail.com')
    to = Email.new(email: 'andy.dev.mailer@gmail.com')
    subject = 'Sending with SendGrid is Fun'
    content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default :from => 'andy.dev.mailer@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def confirmation_instructions
    UserNotifierMailer.confirmation_instructions(User.first, "faketoken", {})
  end

  def reset_password_instructions
    UserNotifierMailer.reset_password_instructions(User.first, "faketoken", {})
  end

  def unlock_instructions
    UserNotifierMailer.unlock_instructions(User.first, "faketoken", {})
  end
end
