class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.text :settings
    end
  end
end
