class DropSettings < ActiveRecord::Migration
  def up
    drop_table :settings
  end

  def down
    create_table :settings do |t|
      t.text :settings

      t.timestamps
    end
  end

end
