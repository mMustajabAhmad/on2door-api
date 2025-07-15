module CountryCodeHelper
  extend ActiveSupport::Concern

  def country_code(country)
    return nil if country.blank?
    country = country.strip

    if country.length == 2
      code = country.upcase
      return code if ISO3166::Country[code]
    end

    match = ISO3166::Country.all.find { |c| c.translations['en'].casecmp?(country) }
    return match.alpha2 if match

    match = ISO3166::Country.all.find { |c| c.translations['en'].downcase.include?(country.downcase) }
    return match.alpha2 if match

    nil
  end
end
