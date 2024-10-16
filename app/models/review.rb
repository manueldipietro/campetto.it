class Review < ApplicationRecord
  belongs_to :field
  belongs_to :user

  validates :titolo, presence: true
  validates :valutazione, presence: true, inclusion: { in: 1..5 }
  validates :testo, presence: true
end

