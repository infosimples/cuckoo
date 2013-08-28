class AddIsBillableToTimeEntry < ActiveRecord::Migration
  def change
    add_column :time_entries, :is_billable, :boolean, default: false
    add_index :time_entries, :is_billable
  end
end
