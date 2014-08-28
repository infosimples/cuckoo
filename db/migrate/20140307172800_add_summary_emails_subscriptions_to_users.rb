class AddSummaryEmailsSubscriptionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscribed_to_admin_summary_email, :boolean, default: false
    add_column :users, :subscribed_to_user_summary_email, :boolean, default: true

    add_index :users, :subscribed_to_admin_summary_email
    add_index :users, :subscribed_to_user_summary_email
  end
end
