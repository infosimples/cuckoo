# Be sure to restart your server when you modify this file.

SMTP_CONFIG_FILE = "#{Rails.root}/config/smtp.yml"

if File.exists?(SMTP_CONFIG_FILE)
  full_smtp_config = YAML.load_file(SMTP_CONFIG_FILE)
  SMTP_CONFIG = full_smtp_config[Rails.env].with_indifferent_access

  Cuckoo::Application.config.action_mailer.delivery_method = :smtp

  Cuckoo::Application.config.action_mailer.smtp_settings = {
    address:        SMTP_CONFIG[:address],
    port:           SMTP_CONFIG[:port],
    authentication: SMTP_CONFIG[:authentication],
    user_name:      SMTP_CONFIG[:user_name],
    password:       SMTP_CONFIG[:password]
  }
end
