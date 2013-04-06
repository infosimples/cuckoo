class CreateTimeEntries < ActiveRecord::Migration
  def change

    create_table :time_entries do |t|
      t.references :user
      t.references :project
      t.references :task
      t.datetime   :started_at
      t.datetime   :ended_at
      t.integer    :time_total
      t.text       :description
    end

  end
end
