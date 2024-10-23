class Field < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_one_attached :image
  has_many :slots, dependent: :destroy

  after_create :create_slots

  geocoded_by :indirizzo, latitude: :latitudine, longitude: :longitudine

  # Esegui il geocoding solo se l'indirizzo è cambiato
  after_validation :geocode_and_handle_errors, if: :indirizzo_changed?

  private

  def create_slots
    Slot.generate_slots(self)
  end

  def geocode_and_handle_errors
    if geocode
      Rails.logger.info "Geocoding successful: #{self.latitudine}, #{self.longitudine}"
    else
      Rails.logger.error "Geocoding failed for address: #{indirizzo}"
      errors.add(:indirizzo, "non è valido o il geocoding non è riuscito.")
    end
  end
end

