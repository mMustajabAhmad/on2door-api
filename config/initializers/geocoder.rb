Geocoder.configure(
  lookup: :google,
  api_key: ENV['GOOGLE_MAPS_API'],
  units: :km,
  use_https: true,
)
