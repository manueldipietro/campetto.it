class CreatePartners < ActiveRecord::Migration[6.1]
  def change
    create_table :partners do |t|
      t.string :email
      t.String :name
      t.string :surname
      t.string :gender
      t.string :birthday
      t.string :mobile

      t.timestamps
    end
  end
end
