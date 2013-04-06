class CreateProjects < ActiveRecord::Migration
  def change

    create_table :projects do |t|
      t.string :name
    end

  end
end
