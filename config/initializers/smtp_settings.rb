# Be sure to restart your server when you modify this file.

SMTP_CONFIG = YAML.load_file("#{Rails.root}/config/smtp_config.yml")

Cuckoo::Application.config.action_mailer.delivery_method = :smtp

Cuckoo::Application.config.action_mailer.smtp_settings = {
    :tls => SMTP_CONFIG[:tls],
    :address => SMTP_CONFIG[:address],
    :port => SMTP_CONFIG[:port],
    :authentication => SMTP_CONFIG[:authentication],
    :user_name => SMTP_CONFIG[:user_name],
    :password => SMTP_CONFIG[:password]
  }
