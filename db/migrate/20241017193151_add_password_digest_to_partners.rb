class AddPasswordDigestToPartners < ActiveRecord::Migration[6.1]
  def change
    add_column :partners, :password_digest, :string
  end
end
