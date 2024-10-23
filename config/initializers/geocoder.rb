Geocoder.configure(
  lookup: :opencagedata,
  api_key: ENV['GEOCODER_OPENCAGEDATA_KEY'],
  timeout: 5,
  units: :km,
  language: :it                    
)