class Field < ApplicationRecord
  has_many :reviews, dependent: :destroy
end
