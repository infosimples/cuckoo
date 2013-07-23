class Project < ActiveRecord::Base

  before_destroy :check_associations_are_empty

  has_many :time_entries

  validates_presence_of :name
  validates_uniqueness_of :name

  #
  # Protected methods.
  #
  protected

  def check_associations_are_empty
    !time_entries.any?
  end

end