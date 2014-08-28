class UserMailer < ActionMailer::Base
  include TimesheetHelper
  helper_method :hours_and_minutes

  before_action :set_date

  default from: "Cuckoo <#{SMTP_CONFIG[:from_email]}>" if defined? SMTP_CONFIG

  def send_day_summary_to_all_subscribers
    users = User.where(subscribed_to_user_summary_email: true)

    users.each do |user|
      user_day_summary_email(user).deliver
    end

    admins = User.where(subscribed_to_admin_summary_email: true)
    admin_day_summary_email(admins).deliver
  end

  def send_week_summary_to_all_subscribers
    users = User.where(subscribed_to_user_summary_email: true)

    users.each do |user|
      user_week_summary_email(user).deliver
    end

    admins = User.where(subscribed_to_admin_summary_email: true)
    admin_week_summary_email(admins).deliver
  end

  def user_day_summary_email(user)
    @user = user
    subject = (@date.strftime('%b/%d')) + ' summary'
    mail(to: user.email, subject: subject, content: 'html',
      template_name: 'user_day_summary_email')
  end

  def admin_day_summary_email(recipients)
    @users = User.all
    subject = 'All users ' + @date.strftime('%b/%d') + ' summary'
    emails = get_emails_from(recipients)
    mail(to: emails, subject: subject, content: 'html',
      template_name: 'admin_day_summary_email')
  end

  def user_week_summary_email(user)
    @user = user
    subject = @date.at_beginning_of_week.strftime('%b/%d') \
              + ' to ' + @date.at_end_of_week.strftime('%b/%d') + ' summary'
    mail(to: user.email, subject: subject, content: 'html',
      template_name: 'user_week_summary_email')
   end

  def admin_week_summary_email(recipients)
    @users = User.all
    subject = 'All users ' + @date.at_beginning_of_week.strftime('%b/%d') \
              + ' to ' + @date.at_end_of_week.strftime('%b/%d') + ' summary'
    emails = get_emails_from(recipients)
    mail(to: emails, subject: subject, content: 'html',
      template_name: 'admin_week_summary_email')
  end

  private

  def set_date
    @date = Time.current.to_date
  end

  def get_emails_from(recipients)
    if (recipients.class == User)
      recipients.email
    else
      recipients.collect(&:email)
    end
  end

end
