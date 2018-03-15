class CreatePackages < ActiveRecord::Migration[5.2]
  def change
    create_table :packages, id: :uuid do |t|
      t.string :registry, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
