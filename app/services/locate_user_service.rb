# frozen_string_literal: true

class LocateUserService
  def call(user, ip_addr)
    location = Geocoder.search(ip_addr).first

    ::UpdateEntityOperation.new(user).call(
      city: location.city,
      country: location.country
    )
  end
end
