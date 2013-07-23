class ChangeTimeTotalToTotalTime < ActiveRecord::Migration
  def change
    rename_column :time_entries, :time_total, :total_time
  end
end
