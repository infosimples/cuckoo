class User < ActiveRecord::Base
  default_scope { order(:name) }

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :registerable, :timeoutable
  # :recoverable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model.
  # attr_accessible :name, :email, :is_admin, :password, :password_confirmation,
  #                 :remember_me

  #
  # Validations.
  #
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_inclusion_of :is_admin, in: [true, false]
  validates_inclusion_of :is_active, in: [true, false]
  validate :only_admins_subscribe_to_admins_email, unless: :is_admin?

  def active_for_authentication?
    super && self.is_active
  end

  def inactive_message
    self.is_active ? super : :deactivated
  end

  private

  def only_admins_subscribe_to_admins_email
    if !is_admin? && subscribed_to_admin_summary_email
      errors.add(:subscribed_to_admin_summary_email,
        "cannot be true for this user")
    end
  end

end
