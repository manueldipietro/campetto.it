class CreateSportsCenters < ActiveRecord::Migration[6.1]
  def change
    create_table :sports_centers do |t|
      t.string :tax_code
      t.string :vat_number
      t.string :campany_name
      t.string :iban
      t.String :email
      t.string :phone

      t.timestamps
    end
  end
end
